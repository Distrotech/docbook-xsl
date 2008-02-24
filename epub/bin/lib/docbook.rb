module DocBook
  class Epub
    CHECKER = "epubcheck"
    STYLESHEET = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', "docbook.xsl"))
    XSLT_PROCESSOR = "xsltproc"
    OUTPUT_DIR = ".epubtmp"
    MIMETYPE = "application/epub+zip"
    META_DIR = "META-INF"
    OEBPS_DIR = "OEBPS"
    ZIPPER = "zip"

    attr_reader :output_dir

    def initialize(docbook_file, output_dir=OUTPUT_DIR)
      @docbook_file = docbook_file
      @output_dir = output_dir
      @meta_dir  = File.join(@output_dir, META_DIR)
      @oebps_dir = File.join(@output_dir, OEBPS_DIR)
      @to_delete = []

      unless File.exist?(@docbook_file)
        raise ArgumentError.new("File #{@docbook_file} does not exist")
      end
    end

    def render_to_file(output_file, verbose=false)
      render_to_epub(output_file, verbose)
      bundle_epub(output_file, verbose)
      cleanup_files(@to_delete)
    end

    def self.invalid?(file)
      # obnoxiously, we can't just check for a non-zero output...
      cmd = "#{CHECKER} #{file}"
      output = `#{cmd} 2>&1`

      if output == "No errors or warnings detected\n" # TODO wow.. this isn't fragile
        return false
      else  
        STDERR.puts output if $DEBUG
        return output
      end  
    end

    private
    def render_to_epub(output_file, verbose)  
      chunk_quietly =  "--stringparam chunk.quietly " + (verbose ? '0' : '1')
      base =  "--stringparam base.dir #{@oebps_dir}/" 
      meta =  "--stringparam epub.metainf.dir #{@meta_dir}/" 
      oebps =  "--stringparam epub.oebps.dir #{@oebps_dir}/" 
      options = "--xinclude #{chunk_quietly} #{base} #{meta} #{oebps}"
      db2epub_cmd = "#{XSLT_PROCESSOR} #{options} #{STYLESHEET} #{@docbook_file}"
      STDERR.puts db2epub_cmd if $DEBUG
      success = system(db2epub_cmd)
      raise "Could not render as .epub to #{output_file}" unless success
      @to_delete << Dir["#{@meta_dir}/*"]
      @to_delete << Dir["#{@oebps_dir}/*"]
    end  

    def bundle_epub(output_file, verbose)  
      quiet = verbose ? "" : "-q"
      # zip -X -r ../book.epub mimetype META-INF OEBPS
      mimetype_filename = write_mimetype()
      meta  = File.basename(@meta_dir)
      oebps  = File.basename(@oebps_dir)
      zip_cmd = "cd #{@output_dir} &&  #{ZIPPER} #{quiet} -X -r  #{output_file} #{mimetype_filename} #{meta} #{oebps}"
      puts zip_cmd if $DEBUG
      success = system(zip_cmd)
      raise "Could not bundle into .epub file to #{output_file}" unless success
    end

    def write_mimetype
      mimetype_filename = File.join(@output_dir, "mimetype")
      File.open(mimetype_filename, "w") {|f| f.print MIMETYPE}
      @to_delete << mimetype_filename
      return File.basename(mimetype_filename)
    end  

    def cleanup_files(file_list)
      file_list.flatten.each {|f|
        File.delete(f)
      }  
    end  

  end
end
