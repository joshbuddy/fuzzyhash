# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fuzzy_hash}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joshua Hull"]
  s.date = %q{2009-03-26}
  s.description = %q{A weird hash with special semantics for regex keys}
  s.email = %q{joshbuddy@gmail.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["Manifest.txt", "Rakefile", "README.rdoc", "VERSION.yml", "lib/fuzzy_hash.rb", "spec/fuzzy_hash_spec.rb", "spec/spec.opts"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/joshbuddy/fuzzy_hash}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A weird hash with special semantics for regex keys}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
