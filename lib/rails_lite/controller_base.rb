require 'erb'
require 'active_support/core_ext'
require_relative 'params'
require_relative 'session'
require 'uri'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    @req, @res, @route_params = req, res, route_params
  end


  def session
    @session ||= Session.new(@req)
  end

  def params
    @params ||= Params.new(@req, @route_params)
  end

  def already_rendered?
  end

  def redirect_to(url)
    @res.status = 302
    @res["location"] = url
    session.store_session(@res)
  end

  def render_content(content, content_type = 'text/plain')
    @res.content_type = content_type
    @res.body = content
    @already_built_responce = @res
    session.store_session(@res)
  end

  def render(template_name)
    content = File.read("views/#{self.class.to_s.underscore}/#{template_name}.html.erb")
    my_erb_template = ERB.new(content).result(binding)
    render_content(my_erb_template)
  end

  def invoke_action(name)
  end
end
