module GameControllers
  LEVEL = {
    simple: { attempts: 15, hints: 2 },
    middle: { attempts: 10, hints: 1 },
    hard: { attempts: 5, hints: 1 }
  }.freeze

  def homepage
    Rack::Response.new(render('menu.html.erb'))
  end

  def gamepage
    Rack::Response.new(render('game.html.erb'))
  end

  def statistics
    Rack::Response.new(render('statistics.html.erb'))
  end

  def rules
    Rack::Response.new(render('rules.html.erb'))
  end

  def win
    if won?
      save_statistics
      Rack::Response.new(render('win.html.erb'))
    else
      Rack::Response.new do |response|
        response.redirect('/')
      end
    end
  end

  def lose
    if lost? && !won?
      Rack::Response.new(render('lose.html.erb'))
    else
      Rack::Response.new do |response|
        response.redirect('/')
      end
    end
  end

  def set_params
    Rack::Response.new do |response|
      @request.session.clear

      @game = Codebreaker::Game.new(LEVEL[@request.params['level'].to_sym][:attempts],
                                    LEVEL[@request.params['level'].to_sym][:hints])

      assign_values(@game)
      store_game(@game)

      response.redirect('/game')
    end
  end

  def show_hint
    Rack::Response.new do |response|
      @game = game
      hint = @game.hint

      @request.session[:hints] << hint unless hint.nil?

      store_game(@game)

      response.redirect('/game')
    end
  end

  def submit_answer
    Rack::Response.new do |response|
      @game = game

      @request.session[:result] = @game.process(@request.params['number'])

      store_game(@game)

      if lost? && !won?
        response.redirect('/lose')
      elsif won?
        response.redirect('/win')
      else
        response.redirect('/game')
      end
    end
  end

  private

  def choose_path
    if active_game?
      gamepage
    else
      homepage
    end
  end

  def assign_values(new_game)
    @request.session[:player_name] = @request.params['player_name']
    @request.session[:level] = @request.params['level']
    @request.session[:hints] = []
    @request.session[:secret_number] = new_game.secret_number
    @request.session[:attempts_number] = new_game.attempts_number
    @request.session[:hints_number] = new_game.hints_number
  end

  def save_statistics
    @statistics = Statistics.new
    @statistics.name = player_name
    @statistics.level = level
    @statistics.attempts_used = attempts_used
    @statistics.hints_used = hints_used
    @statistics.date = DateTime.now.strftime('%d/%m/%Y %H:%M:%S')
    @statistics.save
  end
end
