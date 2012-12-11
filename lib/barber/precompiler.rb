require 'execjs'
require 'json'

module Barber
  class Precompiler
    class << self
      def compile(template)
        new.compile(template)
      end
    end

    def compile(template)
      context.call precompile_function, sanitize(template)
    rescue ExecJS::ProgramError => ex
      raise Barber::PrecompilerError.new(template, ex)
    end

    def precompile_function
      "Barber.precompile"
    end

    def sources
      [precompiler, handlebars]
    end

    def handlebars
      @handlebears ||= File.new(File.expand_path("../javascripts/handlebars.js", __FILE__))
    end

    private
    # This method handles different types of user input. The precompiler
    # can be called from many different places which create interesting 
    # conditions.
    # Case 1: Rake-Pipeline-Web-Filters: calls with a JSON encoded string.
    # Case 2: Matched a multiline Javascript source string
    #   e.g. template: Handlebars.compile('{{foo}}\n{{bar}}').
    #   Coffeescript block strings usually cause this problem.
    # Case 3: "Normal" input. Reading from a file or something like that.
    #
    # Each one of these cases is covered by a test case. If you find another breaking
    # use case please address it here with a regression test.
    def sanitize(template)
      case template
      when nil
        ''
      when /\A".+"\Z/m
        # Case 1
        begin
          JSON.load(%Q|{"template":#{template}}|)['template']
        rescue JSON::ParserError
          template
        end
      else
        # Case 2
        template.gsub(/\\n/,"\n")
      end
    end

    def precompiler
      @precompiler ||= File.new(File.expand_path("../javascripts/handlebars_precompiler.js", __FILE__))
    end

    def context
      @context ||= ExecJS.compile source
    end

    def source
      @source ||= sources.map(&:read).join("\n")
    end
  end
end
