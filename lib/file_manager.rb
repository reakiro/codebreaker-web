module FileManager

  GAME_FILE = 'game.yml'

  def render(template)
    path = File.expand_path("../views/#{template}", File.dirname(__FILE__))
    ERB.new(File.read(path)).result(binding)
  end

  def store_game(game)
    File.open(GAME_FILE, 'w') { |f| f.write game.to_yaml }
  end

  def load_game
    return [] unless File.exist?(GAME_FILE)

    YAML.load_file(GAME_FILE)
  end
end