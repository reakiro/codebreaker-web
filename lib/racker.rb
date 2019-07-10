require 'erb'
require 'pry'

class Racker
  def call(env)
    request = Rack::Request.new(env)
    case request.path
    when '/'           then Rack::Response.new(render('menu.html.erb'))
    when '/game'       then Rack::Response.new(render('game.html.erb'))
    when '/statistics' then Rack::Response.new(render('statistics.html.erb'))
    when '/win'        then Rack::Response.new(render('win.html.erb'))
    when '/lose'       then Rack::Response.new(render('lose.html.erb'))
    else Rack::Response.new('Not Found', 404)
    end
  end

  private

  def render(template)
    path = File.expand_path("../views/#{template}", File.dirname(__FILE__))
    ERB.new(File.read(path)).result(binding)
  end
end
