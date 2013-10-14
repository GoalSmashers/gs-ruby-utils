module GS
  module Utils
    module Assets
      extend self

      attr_accessor :bundled, :hosts, :root, :config, :hard_boosters

      def bundle(type, bundle_id, options = {})
        empty_cache! unless bundled

        cache("#{type}@#{bundle_id}-#{options.to_s.hash}") do
          command_prefix, extension = command(type, options)
          %x{#{command_prefix} #{type}/#{bundle_id}.#{extension}}
        end
      end

      def inline_bundle(type, bundle_id, options = {})
        empty_cache! unless bundled

        cache("#{type}@#{bundle_id}@inline-#{options.to_s.hash}") do
          command_prefix, extension = command(type, options.merge(inline: true))
          %x{#{command_prefix} #{type}/#{bundle_id}.#{extension}}
        end
      end

      def bundles(type, bundle_prefix, groups = nil)
        empty_cache! unless bundled

        cache("#{type}@#{[bundle_prefix, groups].flatten.compact.join('+')}@bundles") do
          command_prefix, extension = command(type, list: true)
          unless groups
            tokens = bundle_prefix.split('/')
            bundle_prefix = tokens[0]
            groups = tokens[1..-1]
          end

          bundle_prefix = bundle_prefix ? "/#{bundle_prefix}" : ''

          groups.each_with_object({}) do |group, memo|
            memo[group] = %x{#{command_prefix} #{type}#{bundle_prefix}/#{group}.#{extension}}.split(',')
          end
        end
      end

      def empty_cache!
        @@_cache = {}
      end

      private

      @@_cache = {}

      def command(type, options = {})
        paths = "-r #{root} -c #{config}"
        bundle = bundled ? '-b' : ''
        boost = hard_boosters ? '-s' : ''
        hosts = hosts ? "-a #{hosts}" : ''
        list = options[:list] ? '-l' : ''
        inline = options[:inline] ? '-i' : ''
        loading_mode = options[:mode] ? "-m #{options[:mode]}" : ''

        extension = case type
        when :stylesheets
          'css'
        when :javascripts
          'js'
        end

        ["#{assetsinc_binary} #{list} #{inline} #{loading_mode} #{bundle} #{boost} #{hosts} #{paths}", extension]
      end

      def assetsinc_binary
        './node_modules/.bin/assetsinc'
      end

      def cache(id, &block)
        @@_cache[id] ||= block.yield
      end
    end
  end
end
