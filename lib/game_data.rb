module GameData
  def player_name
    @request.session[:player_name]
  end

  def level
    @request.session[:level].capitalize
  end

  def attempts_number
    @request.session[:attempts_number]
  end

  def hints_number
    @request.session[:hints_number]
  end

  def hint
    @request.session[:hint]
  end

  def result
    @request.session[:result]
  end

  def secret_number
    @request.session[:secret_number].join
  end

  def attempts_used
    @game = load_game

    @game.stats[:attempts_used]
  end

  def hints_used
    @game = load_game

    @game.stats[:hints_used]
  end

  def rules_txt
    rules = []
    text = File.read('rules.txt')
    text.gsub!(/\r\n?/, "\n")
    text.each_line do |line|
      rules << line
    end
    rules
  end
end
