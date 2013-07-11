# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mail-control/version"

Gem::Specification.new do |s|
  s.name        = "mail-control"
  s.version     = MailControl::VERSION
  s.authors     = ["Andreas Saebjoernsen"]
  s.email       = ["andreas.saebjoernsen@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{LoggedEmail Streams for rails}
  s.description = %q{MailControl is a simple gem for giving both your app and users control over when, if and how emails are sent out.}
  s.homepage    = 'https://github.com/digitalplaywright/mail-control'
  s.license     = 'MIT'

  s.rubyforge_project = "mail-control"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'activerecord', '>= 3'
  s.add_dependency 'activesupport', '>= 3'
  s.add_dependency 'actionpack', '>= 3'
  s.add_development_dependency 'rake'

end
