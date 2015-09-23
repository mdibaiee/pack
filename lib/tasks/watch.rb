require 'filewatch/watch'

module Watch
  def self.watch(file, &fn)
    t = FileWatch::Watch.new
    t.watch(file)
    t.subscribe &fn
  end
end
