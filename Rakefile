$:.unshift( "lib" )
require "lipsum/version.rb"

require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'fileutils'
include FileUtils

PKG_NAME = "lipsum"
PKG_VERS = Lipsum::VERSION
PKG_FILES = %w(ChangeLog COPYING README.rdoc AUTHORS setup.rb) +
 	      Dir.glob("{bin,examples,lib}/**/*")

CLEAN.include ['**/.*.sw?', '*.gem', '.config', 'test/test.log']
RDOC_OPTS = ['--quiet', '--title', "Lipsum, the Documentation",
    "--opname", "index.html",
    "--line-numbers",
    "--main", "README.rdoc",
    "--inline-source"]

desc "Packages up Lipsum."
task :default => [:package]
task :package => [:clean]

task :doc => [:rdoc, :after_doc]

Rake::RDocTask.new do |rdoc|
    rdoc.rdoc_dir = 'doc/rdoc'
    rdoc.options += RDOC_OPTS
    rdoc.main = "README.rdoc"
    rdoc.title = "Lipsum, the Documentation"
    rdoc.rdoc_files.add ['README.rdoc', 'AUTHORS', 'COPYING', 'ChangeLog', 'lib/lipsum.rb']
end

task :after_doc do
    sh %{scp -r doc/rdoc/* #{ENV['USER']}@rubyforge.org:/var/www/gforge-projects/ruby-asp/lipsum}
end

spec =
    Gem::Specification.new do |s|
      s.name = PKG_NAME
      s.version = PKG_VERS
      s.platform = Gem::Platform::RUBY

      s.authors = ["Gregoire Lejeune"]
      s.summary = %q{Get placeholder text from lipsum.com}
      s.email = %q{gregoire.lejeune@free.fr}
      s.homepage = %q{http://github.com/glejeune/lipsum}
      s.description = %q{This class allow you to retrive "lorem ipsum" placeholder text from lipsum.com.}

      s.files = PKG_FILES
      s.require_path = "lib"

      s.rubyforge_project = 'ruby-asp'
      s.has_rdoc = true
      s.extra_rdoc_files = ["README.rdoc", "ChangeLog", "COPYING", "AUTHORS"]
      s.rdoc_options = ["--title", "Lipsum", "--main", "README.rdoc", "--line-numbers"]
    end

Rake::GemPackageTask.new(spec) do |p|
    p.need_tar = true
    p.gem_spec = spec
end

task :install do
  sh %{rake package}
  sh %{sudo gem install pkg/#{PKG_NAME}-#{PKG_VERS}}
end

task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{PKG_NAME}}
end

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/test_*.rb']
#  t.warning = true
#  t.verbose = true
end
