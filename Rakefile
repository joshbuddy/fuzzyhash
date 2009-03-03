require 'hoe'
require 'spec'
require 'spec/rake/spectask'
require 'lib/fuzzy_hash'

Hoe.new('fuzzy_hash', FuzzyHash::Version) do |p|
  p.author = 'Joshua Hull'
  p.email = 'joshbuddy@gmail.com'
  p.summary = 'Weird fuzzy hash-like object for approximate keys'
  p.developer('Joshua Hull', 'joshbuddy@gmail.com')
end

task :spec => 'spec:all'
namespace(:spec) do
  Spec::Rake::SpecTask.new(:all) do |t|
    t.spec_opts ||= []
    t.spec_opts << "-rubygems"
    t.spec_opts << "--options" << "spec/spec.opts"
    t.spec_files = FileList['spec/**/*_spec.rb']
  end

end

task :cultivate do
  system "touch Manifest.txt; rake check_manifest | grep -v \"(in \" | patch"
  system "rake debug_gem | grep -v \"(in \" > `basename \\`pwd\\``.gemspec"
end