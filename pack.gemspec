Gem::Specification.new do |s|
  s.name         = 'pack'
  s.version      = '1.0.0'
  s.date         = '2015-09-23'
  s.summary      = 'Dead-simple self-hosted cloud storage'
  s.authors      = ['Mahdi Dibaiee']
  s.email        = 'mdibaiee@aol.com'
  s.homepage     = 'https://github.com/mdibaiee/pack'
  s.license      = 'GPUv3'
  s.executables << 'pack'
  s.files        = ['lib/app.rb', 'lib/tasks/api.rb', 'lib/tasks/watch.rb']
end
