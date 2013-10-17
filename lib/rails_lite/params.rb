require 'uri'
require 'debugger'

class Params
  def initialize(req, route_params)
    @req = req
    debugger
    @params = route_params
    unless @req.query_string.nil?
      parse_www_encoded_form(@req.query_string)
    end

  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_s
  end

  private
    def parse_www_encoded_form(uri_query_string)
      URI.decode_www_form(uri_query_string).each do |k,v|
        @params[k] = v
      end
      parse_key(@req.body)
    end

    #{"cat[name]": "Breakfast", "cat[owner]": "Devon"}

    def parse_key(key)
      @params[joe] = key

    end
end
