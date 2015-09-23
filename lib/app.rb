require_relative './tasks/api'
require_relative './tasks/watch'

module App
  include API
  include Watch
  @config_path = File.join(Dir.home, '.pack')

  def self.setup
    # Create config file
    unless File.exists? @config_path
      new_file = File.open(@config_path, 'w')
      new_file.write $DEFAULT_CONFIG
      new_file.close
    end

    # Read and Parse config file
    @config_file = File.open(@config_path, 'r')
    @config = JSON.parse(@config_file.read)
    @config['username'] = @config['email'][/[^@]*/]

    self.api.setup(@config)
  end

  def self.api
    HTTP
  end
  def self.watch(path, &fn)
    Watch.watch path, &fn
  end
end
