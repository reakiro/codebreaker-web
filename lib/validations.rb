module Validations
  def active_game?
    game && !won? && !lost?
  end

  def won?
    result == '++++'
  end

  def lost?
    @game = game

    @game.lost? if game
  end
end
