#!/usr/bin/env ruby
lib = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(lib) if File.exist?(lib)

require 'test/unit'
require 'tmpdir'

require 'docbook'
include DocBook

class EpubTest < Test::Unit::TestCase
  def setup
    filedir = File.expand_path(File.join(File.dirname(__FILE__), 'files'))
    @valid_epub = File.join(filedir, "AMasqueOfDays.epub")
    @tmpdir = Dir::tmpdir()

    @simple_bookfile = File.join(filedir, "book.001.xml")
    @simple_epub = Epub.new(@simple_bookfile)
    @rendered_simple_epubfile  = File.join(@tmpdir, "testepub.epub")
    @simple_epub.render_to_file(@rendered_simple_epubfile)
  end

  def test_init
    assert_nothing_raised("A new Epub object should be creatable") {
      Epub.new(@simple_bookfile)
    }
  end

  def test_nonexistent_file
    dne = "thisfiledoesnotexist.dex"
    assert_raises(ArgumentError, "A new Epub should throw an error if the file doesn't exist.") {
      Epub.new(dne)
    }
  end  

  def test_understands_rendering
    assert_respond_to(@simple_epub, :render_to_file, "An Epub should know how to render itself to a file.")
  end

  def test_file_exists_after_rendering
    assert(File.exist?(@rendered_simple_epubfile), "After rendering, the output file should exist.")
  end

  def test_epub_valid_after_rendering
    invalidity = Epub.invalid?(@rendered_simple_epubfile)
    STDERR.puts "INVALIDITY: #{invalidity}" if $DEBUG
    assert(!invalidity, "An .epub file should be valid after being rendered from a DocBook file.")
  end

  def test_empty_file_invalidity
    tmpfile = File.join(@tmpdir, "testepub.epub")
    begin
      File.open(tmpfile, "w") {|f| f.puts }  
      assert(Epub.invalid?(tmpfile), "An empty file should not be a valid .epub file.")
    ensure
      File.delete(tmpfile) rescue Errno::ENOENT
    end  
  end

  def test_existing_file_validity
    invalidity = Epub.invalid?(@valid_epub)
    assert(!invalidity, "An valid .epub file should pass the invalidity check.")
  end

  def teardown

    # delete tmpdir
    File.delete(@rendered_simple_epubfile) rescue Errno::ENOENT
  end  
end
