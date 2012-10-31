module Barber
  module Handlebars
    class InlineCompiler
      class << self
        def call(template)
          "Handlebars.template(#{compile(template)})"
        end

        def compile(template)
          Barber::Handlebars::Precompiler.compile template
        end
      end
    end

    class FileCompiler < InlineCompiler
      class << self
        def call(template)
          "#{super};"
        end
      end
    end
  end
end
