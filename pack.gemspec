Gem::Specification.new do |s|
  s.name         = 'packc'
  s.version      = '0.1.3'
  s.date         = '2015-09-23'
  s.summary      = 'Dead-simple self-hosted cloud storage'
  s.authors      = ['Mahdi Dibaiee']
  s.email        = 'mdibaiee@aol.com'
  s.homepage     = 'https://github.com/mdibaiee/pack'
  s.license      = 'GPUv3'
  s.executables << 'pack'
  s.files        = ['lib/app.rb', 'lib/tasks/api.rb', 'lib/tasks/watch.rb']
  s.add_dependency 'thor', '~> 0.19', '>= 0.19.1'
  s.add_dependency 'daemons', '~> 1.2', '>= 1.2.3'
  s.add_dependency 'filewatch', '~> 0.6', '>= 0.6.5'
  s.add_dependency 'httmultiparty', '~> 0.3', '~> 0.3.16'
end
