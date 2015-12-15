require 'execjs'
require 'json'

module Barber
  class Precompiler
    class << self
      def compile(template, options = nil)
        instance.compile(template, options)
      end

      def compiler_version
        instance.compiler_version
      end

      def handlebars_available?
        require 'handlebars/source' # handlebars precompilation is optional feature.
      rescue LoadError => e
        raise e unless ['cannot load such file -- handlebars/source', 'no such file to load -- handlebars/source'].include?(e.message)
      ensure
        return !!defined?(Handlebars::Source)
      end

      private

      def instance
        @instance ||= new
      end
    end

    def compile(template, options = nil)
      context.call precompile_function, sanitize(template), options
    rescue ExecJS::ProgramError => ex
      raise Barber::PrecompilerError.new(template, ex)
    end

    def precompile_function
      "Barber.precompile"
    end

    def sources
      sources = [precompiler]
      sources << handlebars if self.class.handlebars_available?
      sources
    end

    def handlebars
      @handlebars ||= File.new(Handlebars::Source.bundled_path)
    end

    def compiler_version
      "handlebars:#{handlebars_version}"
    end

    private
    # This method handles different types of user input. The precompiler
    # can be called from many different places which create interesting
    # conditions.
    # Case 1: Rake-Pipeline-Web-Filters: calls with a JSON encoded string.
    # Case 2: Sanitize using a RegExp
    # Case 3: "Normal" input. Reading from a file or something like that.
    #
    # Each one of these cases is covered by a test case. If you find another breaking
    # use case please address it here with a regression test.
    def sanitize(template)
      begin
        if template =~ /\A".+"\Z/m
          # Case 1
          sanitize_with_json(template)
        else
          # Case 2
          sanitize_with_regexp(template)
        end
      rescue JSON::ParserError
        # Case 3
        template
      end
    end

    def sanitize_with_json(template)
      JSON.load(%Q|{"template":#{template}}|)['template']
    end

    def sanitize_with_regexp(template)
      if template.respond_to? :gsub
        sanitized = template.gsub(/\\n/,"\n")
        sanitized = sanitized.gsub(/\\["']/, '"')
        sanitized
      else
        template
      end
    end

    def precompiler
      @precompiler ||= File.new(File.expand_path("../javascripts/handlebars_precompiler.js", __FILE__))
    end

    def context
      @context ||= ExecJS.compile source
    end

    def source
      # hbs 3 has no reference to `window` and `self`.
      <<-SOURCE
if (typeof window === 'undefined') {
  window = this;
};
if (typeof self === 'undefined') {
  self = this;
};
#{sources.map(&:read).join("\n;\n")}
      SOURCE
    end

    def handlebars_version
      @handlebars_version ||= context.eval('Handlebars.VERSION')
    end
  end
end
