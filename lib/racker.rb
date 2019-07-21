require 'erb'
require 'yaml'
require 'date'
require 'pry'
require 'codebreaker'
require_relative 'game_data'
require_relative 'game_controllers'
require_relative 'file_manager'
require_relative 'validations'
require_relative 'statistics'

class Racker
  include GameData
  include GameControllers
  include FileManager
  include Validations

  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when '/'              then choose_path
    when '/game'          then choose_path
    when '/statistics'    then statistics
    when '/win'           then win
    when '/lose'          then lose
    when '/rules'         then rules
    when '/set_params'    then set_params
    when '/show_hint'     then show_hint
    when '/submit_answer' then submit_answer
    else Rack::Response.new('Not Found', 404)
    end
  end
end
