require 'execjs'

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
    # Case 2: Matched a string in a Javascript source file that does not 
    #   behave the same way in ruby. IE: template: Handlebars.compile('{{foo}}\n').
    #   Matching that string with a regex in Ruby generates a string with a literal \n.
    #   That same string in JavaScript does not contain a literal \n. These semantics
    #   break the compiler when \n are present in view helpers. Coffeescript block strings
    #   usually cause this problem.
    # Case 3: "Normal" input. Reading from a file or something like that.
    #
    # Each one of these cases is covered by a test case. If you find another breaking
    # use case please address it here with a regression test.
    def sanitize(template)
      begin
        if template =~ /\A".+"\Z/m
          # Case 1
          MultiJson.load(%Q|{"template":#{template}}|)['template']
        else
          # Case 2: evaluate a literal JS string in Ruby in the JS context
          # to get an equivalent Ruby string back. This will convert liternal \n's
          # to new lines. This is safer than trying to modify the string using regex.
          context.eval("'#{template}'")
        end
      rescue
        # Case 3
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
      @source ||= sources.map(&:read).join("\n")
    end
  end
end
