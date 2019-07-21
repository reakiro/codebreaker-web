require 'pry'
require 'erb'

describe Racker do
  include Rack::Test::Methods

  STATS_FILE = 'stats.yml'.freeze

  PATHS = {
    homepage: '/',
    game: '/game',
    statistics: '/statistics',
    win: '/win',
    lose: '/lose',
    rules: '/rules',
    set_params: '/set_params',
    show_hint: '/show_hint',
    submit_answer: '/submit_answer'
  }.freeze

  TEXT = {
    homepage: 'Try to guess 4-digit number, that consists of numbers in a range from 1 to 6.',
    rules: 'Codebreaker is a logic game in which a code-breaker tries to break a secret code',
    stats_with_winners: 'Top of Players',
    stats_with_no_winners: 'There are no winners yet! Be the first!',
    win: 'You won the game!',
    lose: 'You lost the game!'
  }.freeze

  def app
    Rack::Builder.parse_file('config.ru').first
  end

  describe 'homepage' do
    let(:player_name) { 'darina' }

    context 'when no active game' do
      it 'goes to homepage' do
        get PATHS[:homepage]
        expect(last_response.body).to include(TEXT[:homepage])
      end
    end

    context 'when there\'s an active game' do
      before do
        get PATHS[:set_params], player_name: player_name, level: 'simple'
      end

      it 'goes to gamepage' do
        get PATHS[:homepage]
        expect(last_response.body).to include("Hello, #{player_name}!")
      end
    end
  end

  describe 'gamepage' do
    let(:player_name) { 'darina' }
    let(:simple) { 'simple' }
    let(:middle) { 'middle' }
    let(:hard) { 'hard' }
    let(:levels) { [simple, middle, hard] }

    context 'when no active game' do
      it 'goes to homepage' do
        get PATHS[:game]
        expect(last_response.body).to include(TEXT[:homepage])
      end
    end

    context 'when there\'s an active game' do
      it 'goes to gamepage and creates a new game with correct level' do
        levels.each do |level|
          get PATHS[:set_params], player_name: player_name, level: level
          get PATHS[:game]
          expect(last_response.body).to include(level.capitalize.to_s)
        end
      end
    end
  end

  describe 'rules' do
    it 'opens rules page' do
      get PATHS[:rules]
      expect(last_response.body).to include(TEXT[:rules])
    end
  end

  describe 'statistics' do
    context 'when there are winners' do
      let(:statistics) { Statistics.new }

      before do
        statistics.name = 'darina'
        statistics.level = 'simple'
        statistics.attempts_used = 1
        statistics.hints_used = 0
        statistics.date = DateTime.now.strftime('%d/%m/%Y %H:%M:%S')
        statistics.save
      end

      it do
        get PATHS[:statistics]
        expect(last_response.body).to include(TEXT[:stats_with_winners])
      end
    end

    context 'when there\'s no winners' do
      before do
        File.delete(STATS_FILE) if File.exist?(STATS_FILE)
      end

      it do
        get PATHS[:statistics]
        expect(last_response.body).to include(TEXT[:stats_with_no_winners])
      end
    end
  end

  describe 'win' do
    let(:player_name) { 'darina' }
    let(:level) { 'simple' }
    let(:game) { Codebreaker::Game.new(15, 2) }

    context 'when there\'s a winner' do
      before do
        get PATHS[:set_params], player_name: player_name, level: level
        env 'rack.session', game: game
        game.instance_variable_set(:@secret_number, [1, 2, 3, 4])
        get PATHS[:submit_answer], number: 1234
      end

      it 'opens win page' do
        get PATHS[:win]
        expect(last_response.body).to include(TEXT[:win])
      end
    end

    context 'when there\'s no winner and game is active' do
      before do
        get PATHS[:set_params], player_name: player_name, level: level
      end

      it 'redirects to gamepage' do
        get PATHS[:win]
        follow_redirect!
        expect(last_response.body).to include("Hello, #{player_name}!")
      end
    end

    context 'when there\'s no winner and no active game' do
      it 'redirects to homepage' do
        get PATHS[:win]
        follow_redirect!
        expect(last_response.body).to include(TEXT[:homepage])
      end
    end
  end

  describe 'lose' do
    let(:player_name) { 'darina' }
    let(:level) { 'simple' }

    context 'when there\'s a loser' do
      before do
        get PATHS[:set_params], player_name: player_name, level: level
        15.times do
          get PATHS[:submit_answer], number: 1234
        end
      end

      it 'opens lose page' do
        get PATHS[:lose]
        expect(last_response.body).to include(TEXT[:lose])
      end
    end

    context 'when there\'s no loser and game is active' do
      before do
        get PATHS[:set_params], player_name: player_name, level: level
      end

      it 'redirects to gamepage' do
        get PATHS[:lose]
        follow_redirect!
        expect(last_response.body).to include("Hello, #{player_name}!")
      end
    end

    context 'when there\'s no loser and no active game' do
      it 'redirects to homepage' do
        get PATHS[:lose]
        follow_redirect!
        expect(last_response.body).to include(TEXT[:homepage])
      end
    end
  end
end
