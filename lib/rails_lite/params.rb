require 'uri'
require 'debugger'

class Params
  def initialize(req, route_params)
    @req = req
    @params = {}

    unless @req.query_string.nil?
      parse_www_encoded_form(@req.query_string)
    end

    unless @req.body.nil?
      parse_www_encoded_form(@req.body)
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
      URI.decode_www_form(uri_query_string).each do |k,val|
        keys_of_pair = parse_key(k)
        nested_hash = keys_array_to_hash(keys_of_pair, val)
        recursive_merge(@params, nested_hash)
      end
    end

    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end

    def recursive_merge(hash1, hash2)
      hash1.merge!(hash2) do |key, val1, val2|
        recursive_merge(val1, val2)
      end
    end

    def keys_array_to_hash(keys, val)
      #keys is an array of keys to be converted to a nested hash
      nested_hash = {keys.pop => val}

      keys.reverse.inject(nested_hash) do |hash, key|
        nested_hash = { key => hash }
      end
      nested_hash
    end

end
