module Validations
  def valid_game?
    load_game != []
  end

  def won?
    result == "++++"
  end

  def lost?
    @game = load_game

    @game.lost? if valid_game?
  end
end