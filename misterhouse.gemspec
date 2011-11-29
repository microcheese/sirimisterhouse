# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "misterhouse"
  s.version     = "0.0.2" 
  s.authors     = ["ereiter"]
  s.email       = [""]
  s.homepage    = ""
  s.summary     = %q{Plugin to control Home Automation Server Misterhouse}
  s.description = %q{Plugin to control Home Automation Server Misterhouse}

  #s.rubyforge_project = "misterhouse"

  #s.files         = `git ls-files 2> /dev/null`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/* 2> /dev/null`.split("\n")
  #s.executables   = `git ls-files -- bin/* 2> /dev/null`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
