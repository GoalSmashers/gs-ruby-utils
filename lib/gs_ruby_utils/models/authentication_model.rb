module GS
  module Models
    module AuthenticationModel
      attr_accessor :password
      attr_accessor :password_confirmation

      def self.included(klass)
        klass.extend(AuthenticationModelClassMethods)
      end

      # ATTRIBUTES
      def email=(new_email)
        self[:email] = new_email.downcase if new_email
      end

      def password=(new_password)
        @password = new_password
        @password_confirmation = new_password

        self.salt = self.class::secure_digest(Time.now.to_f, (1..10).map{ rand.to_s })
        self.crypted_password = self.class::secure_digest([@password, salt])
      end

      def set_memorize_token!(token = nil, expires_at = 1.year.since)
        token = self.class::secure_digest([Time.now.to_f, 'memorize', 'token']) unless token

        update(
          memorize_token: token,
          memorize_token_expires_at: expires_at
        )
      end

      def set_reset_token
        self.reset_password_token = self.class::secure_digest([crypted_password, Time.now.to_f])[0..24]
        self.reset_password_token_expires_at = 2.days.from_now
      end

      def set_reset_token!
        set_reset_token
        save
      end

      def valid_reset_token?
        reset_password_token && reset_password_token_expires_at > Time.now
      end

      def reset_password(password, password_confirmation)
        self.password = password
        self.password_confirmation = password_confirmation
        self.reset_password_token = nil
        self.reset_password_token_expires_at = nil
        self.save
      end

      def clear_memorize_token
        set_memorize_token!(nil, nil)
      end

      def set_activation_token
        self.activation_token = self.class::secure_digest([Time.now.to_f, email, 'activation', 'token'])
      end

      def clear_activation_token
        self.activation_token = nil
      end
    end

    module AuthenticationModelClassMethods
      def authenticate_by_credentials(email, password)
        return nil unless email

        user = self.first(email: email.downcase)
        return nil unless user
        return user if secure_digest([password, user.salt]) == user.crypted_password
      end

      def authenticate_by_token(token)
        self.filter(memorize_token: token).and { memorize_token_expires_at > Time.now }.first
      end

      def secure_digest(*args)
        ::Digest::SHA1.hexdigest(args.flatten.join('-GS-'))
      end
    end
  end
end
