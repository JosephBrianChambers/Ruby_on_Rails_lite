require 'json'
require 'webrick'
require 'debugger'

class Session
  COOKIE_NAME = '_rails_lite_app'

  def initialize(req)
    cookie = req.cookies.find {|c| c.name == COOKIE_NAME }
    @cookie_value_hash = cookie.nil? ? {} : JSON.parse(cookie.value)
  end

  def [](key)
    @cookie_value_hash[key]
  end

  def []=(key, val)
    @cookie_value_hash[key] = val
  end

  def store_session(res)
    #for clarity
    cookie_value = @cookie_value_hash.to_json
    new_cookie = WEBrick::Cookie.new(COOKIE_NAME, cookie_value)
    res.cookies << new_cookie
  end

end