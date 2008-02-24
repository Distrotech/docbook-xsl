#!/usr/bin/env ruby
lib = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(lib) if File.exist?(lib)

require 'tmpdir'

require 'rubygems'
require 'spec'

require 'docbook'

describe DocBook::Epub do
  before(:all) do
    filedir = File.expand_path(File.join(File.dirname(__FILE__), 'files'))
    exampledir = File.expand_path(File.join(File.dirname(__FILE__), 'examples'))
    @valid_epub = File.join(exampledir, "AMasqueOfDays.epub")
    @tmpdir = Dir::tmpdir()

    @simple_bookfile = File.join(filedir, "book.001.xml")
    @simple_epub = DocBook::Epub.new(@simple_bookfile)
    @rendered_simple_epubfile  = File.join(@tmpdir, "testepub.epub")
    @simple_epub.render_to_file(@rendered_simple_epubfile)
  end

  it "should be able to be created" do
    lambda {
      DocBook::Epub.new(@simple_bookfile)
    }.should_not raise_error
  end

  it "should fail on a nonexistent file" do
    dne = "thisfiledoesnotexist.dex"
    lambda {
      DocBook::Epub.new(dne)
    }.should raise_error(ArgumentError)
  end  

  it "should be able to render to a file" do
    @simple_epub.should respond_to(:render_to_file)
  end

  it "should create a file after rendering" do
    @rendered_simple_epubfile.should satisfy {|rse| File.exist?(rse)}
  end

  it "should be valid .epub after rendering" do
    pending(".epub validity is what we're working toward...") {
      @rendered_simple_epubfile.should_not satisfy {|rse| 
        invalidity = DocBook::Epub.invalid?(rse)
        STDERR.puts "INVALIDITY: #{invalidity}" if $DEBUG
        invalidity
      }  
    }  
  end

  it "should report an empty file as invalid" do
    tmpfile = File.join(@tmpdir, "testepub.epub")
    begin
      File.open(tmpfile, "w") {|f| f.puts }  
      tmpfile.should satisfy {|dbf| DocBook::Epub.invalid?(dbf)}
    ensure
      File.delete(tmpfile) rescue Errno::ENOENT
    end  
  end

  it "should confirm that a valid .epub file is valid" do
    $DEBUG = true
    @valid_epub.should_not satisfy {|ve| DocBook::Epub.invalid?(ve)}
  end

  after(:all) do
    # delete tmpdir
    File.delete(@rendered_simple_epubfile) rescue Errno::ENOENT
  end  
end
