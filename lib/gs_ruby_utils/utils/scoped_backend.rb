class ScopedBackend < I18n::Backend::Simple

  attr_accessor :last_modified

  def initialize
    super

    @translations_with_scope = {}
    @last_modified = last_modification_time
  end

  def last_modified
    @last_modified = last_modification_time if @last_modified == nil || Application.env?(:development)
    @last_modified
  end

  def scoped_translations(locale, scope_id)
    init_translations unless initialized?
    reset_translations if Application.env?(:development)

    translations_with_scope[locale.to_sym][scope_id.to_sym]
  end

  protected

  def load_file(filename)
    type = File.extname(filename).tr('.', '').downcase
    raise UnknownFileType.new(type, filename) unless method(:"load_#{type}")

    data = send(:"load_#{type}", filename)
    locale = data.keys.first.to_sym
    prepare_translations(locale, data.values.first, source: filename)
  end

  def prepare_translations(locale, data, options = {})
    translations[locale] ||= {}
    translations_with_scope[locale] ||= {}

    if options[:source].index(Application.root) == 0
      data = descope_keys(data, locale)
      translations[locale].deep_merge!(data)
    else
      translations[locale].deep_merge!(data.deep_symbolize_keys)
    end
  end

  private

  attr_reader :translations_with_scope

  SCOPE_SELECTOR = /[\(\)]/

  def i18n_files
    I18n.load_path
  end

  def invalidate
    new_modification_time = last_modification_time
    if new_modification_time > @last_modified
      @last_modified = new_modification_time
      @initialized = false
    end
  end

  def last_modification_time
    i18n_files.collect { |p| File.mtime(p) }.max.to_i
  end

  def reset_translations
    @initialized = false
    @translations_with_scope = {}
    i18n_files.each { |f| load_file(f) }
  end

  def descope_keys(hash, locale, prefixes = [])
    return hash unless hash.is_a?(Hash)

    hash.each_with_object({}) do |(key, value), memo|
      key, scopes = key.split(SCOPE_SELECTOR)
      scopes = scopes ? scopes.split(',') : []
      prefixed_key = (prefixes + [key]).join('.')
      value = descope_keys(value, locale, prefixes + [key])

      unless value.is_a?(Hash)
        scopes.each do |scope|
          translations_with_scope[locale][scope.to_sym] ||= {}
          translations_with_scope[locale][scope.to_sym][prefixed_key] ||= value
        end
      end

      memo[key.to_sym] = value
    end
  end
end
