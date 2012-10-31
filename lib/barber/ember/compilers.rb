module Barber
  module Ember
    class InlineCompiler
      class << self
        def call(template)
          "Ember.Handlebars.template(#{compile(template)})"
        end

        def compile(template)
          Barber::Ember::Precompiler.compile template
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
