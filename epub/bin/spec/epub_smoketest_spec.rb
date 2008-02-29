#!/usr/bin/env ruby
lib = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(lib) if File.exist?(lib)

require 'tmpdir'
require 'fileutils'

require 'rubygems'
require 'spec'

require 'docbook'

describe DocBook::Epub do
  before(:all) do
    @testdocsdir = File.expand_path(File.join(File.dirname(__FILE__), 'testdocs'))
    @tmpdir = File.join(Dir::tmpdir(), "epubspec"); Dir.mkdir(@tmpdir)
    $DEBUG = true
  end

  it "should be able to render a valid .epub for each test document in the DocBook testdocs repo" do
    #Dir["#{@testdocsdir}/author.001.xml"].each {|xml_file|
    Dir["#{@testdocsdir}/*.xml"].each {|xml_file|
      epub = DocBook::Epub.new(xml_file, @tmpdir)
      epub_file = File.join(@tmpdir, "smoketest.epub")
      epub.render_to_file(epub_file, $DEBUG)
      FileUtils.copy(epub_file, ".smt.epub") if $DEBUG
      epub_file.should_not satisfy {|ef|
        invalidity = DocBook::Epub.invalid?(ef)
        STDERR.puts "INVALIDITY: #{invalidity} on #{xml_file}" if invalidity && $DEBUG
        invalidity
      }  
    }  
  end

  after(:all) do
    FileUtils.rm_r(@tmpdir, :force => true)
  end  
end
