require 'json'

module Barber
  module Handlebars
    class Precompiler
      class << self
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
          raise PrecompilerError.new(source, ex)
        end

        def precompile_function
          "Barber.precompile"
        end

        def handlebars_path
          File.expand_path("../javascripts/handlebars.js", __FILE__)
        end

        def precompiler_path
          File.expand_path("../javascripts/handlebars_precompiler.js", __FILE__)
        end

        def sources
          [handlebars_path]
        end

        private
        def context
          @context ||= ExecJS.compile source
        end

        def source
          @source ||= sources.map {|path|
            File.read(path)
          }.join "\n"
        end
      end
    end
  end
end
