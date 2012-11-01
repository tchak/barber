require 'json'
require 'execjs'

module Barber
  class Precompiler
    class << self
      def compile(template)
        new.compile(template)
      end
    end

    def compile(source)
      # if the source is a prescaped JSON string then 
      # it should be parse, else just use it as is
      content = begin
                  JSON.load source
                rescue JSON::ParserError
                  source
                end

      context.call precompile_function, content
    rescue ExecJS::ProgramError => ex
      raise Barber::PrecompilerError.new(source, ex)
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
