module DocBook
  class Epub
    CHECKER = "epubcheck"
    STYLESHEET = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', "docbook.xsl"))
    XSLT_PROCESSOR = "xsltproc"
    OUTPUT_DIR = ".epubtmp/"

    attr_reader :output_dir

    def initialize(docbook_file, output_dir=OUTPUT_DIR)
      @docbook_file = docbook_file
      @output_dir = output_dir
      unless File.exist?(@docbook_file)
        raise ArgumentError.new("File #{@docbook_file} does not exist")
      end
    end

    def render_to_file(output_file, verbose=false)
      chunk_quietly = verbose ? '0' : '1'
      cmd = "#{XSLT_PROCESSOR} --xinclude --stringparam chunk.quietly #{chunk_quietly} --stringparam base.dir #{@output_dir} #{STYLESHEET} #{@docbook_file}"
      STDERR.puts cmd if $DEBUG
      success = system(cmd)
      raise "Could not render as .epub to #{output_file}" unless success
      File.open(output_file, "w") {|f| f.puts }
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
  end
end
