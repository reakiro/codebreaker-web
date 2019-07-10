require 'erb'
require 'pry'
require_relative '../app/codebreaker.rb'

class Racker

  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when '/'           then Rack::Response.new(render('menu.html.erb'))
    when '/game'       then Rack::Response.new(render('game.html.erb'))
    when '/statistics' then Rack::Response.new(render('statistics.html.erb'))
    when '/win'        then Rack::Response.new(render('win.html.erb'))
    when '/lose'       then Rack::Response.new(render('lose.html.erb'))
    when '/set_params' then set_params
    else Rack::Response.new('Not Found', 404)
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", File.dirname(__FILE__))
    ERB.new(File.read(path)).result(binding)
  end

  def player_name
    @request.cookies['player_name'] || 'unknown'
  end

  def level
    @request.cookies['level']
  end

  def set_params
    Rack::Response.new do |response|
      response.set_cookie('player_name', @request.params['player_name'])
      response.set_cookie('level', @request.params['level'])
      
      case @request.params['level']
      when 'simple' then @game = Game.new(15, 2)
      when 'middle' then @game = Game.new(10, 1)
      when 'hard'   then @game = Game.new(5, 1)
      end

      response.set_cookie('attempts_number', @game.attempts_number)
      response.set_cookie('hints_number', @game.hints_number)

      response.redirect('/game')
    end
  end
end
