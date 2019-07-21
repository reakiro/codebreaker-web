class Statistics
  STATS_FILE = 'stats.yml'.freeze

  attr_accessor :name, :level, :attempts_used, :hints_used, :date

  def initialize
    @name = ''
    @level = ''
    @attempts_used = 0
    @hints_used = 0
    @date = ''
  end

  def save
    new_stats = stats << self
    write_to_file(new_stats)
  end

  def stats
    return [] unless File.exist?(STATS_FILE)

    YAML.load_file(STATS_FILE)
  end

  def write_to_file(new_stats)
    File.open(STATS_FILE, 'w') { |f| f.write new_stats.to_yaml }
  end
end
