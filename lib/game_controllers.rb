module GameControllers
  def homepage
    if active_game?
      Rack::Response.new(render('game.html.erb'))
    else
      Rack::Response.new(render('menu.html.erb'))
    end
  end

  def game
    if active_game?
      Rack::Response.new(render('game.html.erb'))
    else
      Rack::Response.new do |response|
        response.redirect('/')
      end
    end
  end

  def statistics
    Rack::Response.new(render('statistics.html.erb'))
  end

  def rules
    puts "hello"
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

      @request.session[:player_name] = @request.params['player_name']
      @request.session[:level] = @request.params['level']
      
      case @request.params['level']
      when 'simple' then @game = Codebreaker::Game.new(15, 2)
      when 'middle' then @game = Codebreaker::Game.new(10, 1)
      when 'hard'   then @game = Codebreaker::Game.new(5, 1)
      end

      assign_values(@game)
      store_game(@game)

      response.redirect('/game')
    end
  end

  def show_hint
    Rack::Response.new do |response|
      @game = load_game

      unless @game.hint.nil?
        @request.session[:hint] = @game.hint
      else
        @request.session[:hint] = "no hints left"
      end

      store_game(@game)

      response.redirect('/game')
    end
  end

  def submit_answer
    Rack::Response.new do |response|
      @game = load_game

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

  def assign_values(game)
    @request.session[:secret_number] = game.secret_number
    @request.session[:attempts_number] = game.attempts_number
    @request.session[:hints_number] = game.hints_number
  end

  def save_statistics
    @statistics = Statistics.new
    @statistics.name = player_name
    @statistics.level = level
    @statistics.attempts_used = attempts_used
    @statistics.hints_used = hints_used
    @statistics.date = DateTime.now.strftime("%d/%m/%Y %H:%M:%S")
    @statistics.save
  end
end