module Barber
  class InlinePrecompiler
    class << self
      def call(template)
        "Handlebars.template(#{compile(template)})"
      end

      def compile(template)
        Barber::Precompiler.compile template
      end
    end
  end

  class FilePrecompiler < InlinePrecompiler
    class << self
      def call(template)
        "#{super};"
      end
    end
  end
end
