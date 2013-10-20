require 'erb'
require 'active_support/core_ext'
require_relative 'params'
require_relative 'session'
require 'uri'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res

    @already_build_responce = false
    @route_params = route_params
  end


  def session
    @session ||= Session.new(@req)
  end

  def params
    @params ||= Params.new(@req, @route_params)
  end

  def already_rendered?
    @already_build_responce
  end

  def redirect_to(url)
    @res.status = 302
    @res["location"] = url
    session.store_session(@res)
    @already_built_responce = true
  end

  def render_content(content, content_type = 'text/plain')
    raise "content already rendered" if already_rendered?

    @res.content_type = content_type
    @res.body = content
    session.store_session(@res)
  end

  def render(template_name)
    raise "content already rendered" if already_rendered?

    filename = [
      "views",
      self.class.to_s.underscore,
      "#{template_name}.html.erb"
    ].join('/')

    content = File.read(filename)
    my_erb_template = ERB.new(content).result(binding)
    render_content(my_erb_template)
  end

  def invoke_action(name)
    self.send(name)
    render(name) unless already_build_response?
  end
end




















