module Validations
  def active_game?
    valid_game? && !won? && !lost?
  end

  def valid_game?
    load_game != []
  end

  def won?
    result == '++++'
  end

  def lost?
    @game = load_game

    @game.lost? if valid_game?
  end
end
