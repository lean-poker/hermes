
class HttpRequestLight

  def initialize(url)
    uri = URI(url)
    @host, @port, @path, @query = uri.host, uri.port, uri.path, uri.query
  end

  def do_request(method, message = nil, timeout = 10, &block)
    begin
      try_request(method, message, timeout, &block)
    rescue Exception => e
      yield true, { :message => e.message, :code => nil } if block_given?
    end
  end

  class << self
    def post(url, message, timeout = 10, &block)
      self.new(url).do_request(:post, message, timeout, &block)
    end

    def get(url, &block)
      self.new(url).do_request(:get, &block)
    end

    def delete(url, &block)
      self.new(url).do_request(:delete, &block)
    end
  end

  private

  def try_request(method, message = nil, timeout = 30)
    response = build_http_connection(timeout).start do |http|
      http.request(build_request(method, message))
    end

    yield response.code.to_i != 200, { :message => response.body, :code => response.code.to_i} if block_given?
  end

  def build_request(method, message)
    if method == :post
      req = Net::HTTP::Post.new(@path)
      req.set_form(message)
      req
    elsif method == :get
      Net::HTTP::Get.new(@path + '?' + @query)
    elsif method == :delete
      Net::HTTP::Delete.new(@path)
    end
  end

  def build_http_connection(timeout)
    http_connection = Net::HTTP.new(@host, @port)
    http_connection.open_timeout = timeout
    http_connection.read_timeout = timeout
    http_connection
  end
end