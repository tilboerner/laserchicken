class UrlSanitizer

  attr_reader :url


  #@param [String] uri_str
  #@param [Boolean] autofix
  def initialize(uri_str, autofix=true)
    raise ArgumentError, 'Argument is not a String' unless uri_str.is_a?(String)
    raise ArgumentError, 'Argument should not be blank' if uri_str.blank?

    @url = uri_str
    fix_url if autofix

  end

  def valid?
    return false if has_whitespaces?
    return false if has_trailing_slashes?
    return false unless has_scheme?

    return true
  end

  # fix common problems
  # example: FeedUrl.new('github.com', true)
  # example: url = FeedUrl.new('github.com', flase); url.fix_url
  def fix_url
    remove_whitespaces if has_whitespaces?
    remove_trailing_slashes
    add_default_scheme unless has_scheme?
  end
  alias_method :fix!, :fix_url

  # Add protocol to url
  private
  def add_default_scheme
    @scheme = "http://"
    @url = "#{@scheme}#{@url}"
  end

  # Checks if the last char of url == slash
  # @return [Boolean]
  def has_trailing_slash?
    @url.last.eql?('/') ? true : false
  end

  # Checks if the last char of url == backslash
  # @return [Boolean]
  private
  def has_trailing_backslash?
    @url.last.eql?('\\') ? true : false
  end

  #convmethod to perform both checks (slash and backslash)
  # @return [Boolean]
  def has_trailing_slashes?
    (has_trailing_backslash? or has_trailing_slash?) ? true : false
  end

  # removes trailing slash while last char == slash
  def remove_trailing_slash
    while(has_trailing_slash?) do
      @url.chomp!('/')
    end
  end

  # removes trailing slash while last char == backslash
  def remove_trailing_backslash
    while(has_trailing_backslash?) do
      @url.chomp!('\\')
    end
  end

  def remove_trailing_slashes
    remove_trailing_backslash if has_trailing_backslash?
    remove_trailing_slash if has_trailing_slash?
  end

  def has_whitespaces?
    (@url =~ /\s+/) ? true : false
  end

  def remove_whitespaces
    @url.gsub!(/\s+/, "")
  end

  def has_scheme?
    (@url.starts_with?('http://') or @url.starts_with?('https://')) ? true : false
  end

end