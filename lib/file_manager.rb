module FileManager
  def render(template)
    path = File.expand_path("../views/#{template}", File.dirname(__FILE__))
    ERB.new(File.read(path)).result(binding)
  end
end
