Gem::Specification.new do |s|
  s.name = "kiwi-ecs"
  s.version = "0.1.1"
  s.summary = "An entity component system with a nice api, fit for a variety of use cases"
  s.description = "== Description

#{File.read("README.md").lines[2...]}"
  s.extra_rdoc_files = ['README.md']
  s.authors = ["Jonas Everaert"]
  s.files = Dir.glob("lib/**/*.rb")
  s.homepage = "https://github.com/jomy10/kiwi-ecs-ruby"
  s.license = "LGPL-3.0-or-later"
end
