module Barber
  module Ember
    class Precompiler < Barber::Precompiler
      def handlebars
        @ember ||= File.new(File.expand_path("../../javascripts/ember-template-compiler.js", __FILE__))
      end

      def precompiler
        @precompiler = File.new(File.expand_path("../../javascripts/ember_precompiler.js", __FILE__))
      end
    end
  end
end
