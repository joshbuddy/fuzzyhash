# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fuzzyhash}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joshua Hull"]
  s.date = %q{2009-06-16}
  s.description = %q{A weird hash with special semantics for regex keys}
  s.email = %q{joshbuddy@gmail.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "Manifest.txt",
     "README.rdoc",
     "Rakefile",
     "VERSION.yml",
     "lib/fuzzy_hash.rb",
     "spec/fuzzy_hash_spec.rb",
     "spec/spec.opts"
  ]
  s.homepage = %q{http://fuzzyhash.rubyforge.org/}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{fuzzyhash}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{A weird hash with special semantics for regex keys}
  s.test_files = [
    "spec/fuzzy_hash_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
