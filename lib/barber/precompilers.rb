module Barber
  class InlinePrecompiler
    class << self
      def call(template, options = nil)
        "Handlebars.template(#{compile(template, options)})"
      end

      def compile(template, options = nil)
        Barber::Precompiler.compile template, options
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
