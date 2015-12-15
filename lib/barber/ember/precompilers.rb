module Barber
  module Ember
    class InlinePrecompiler
      class << self
        def call(template, options = nil)
          "Ember.Handlebars.template(#{compile(template, options)})"
        end

        def compile(template, options = nil)
          Barber::Ember::Precompiler.compile template, options
        end
      end
    end

    class FilePrecompiler < InlinePrecompiler
      class << self
        def call(template, options = nil)
          "#{super};"
        end
      end
    end
  end
end
