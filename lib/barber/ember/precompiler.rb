module Barber
  module Ember
    class Precompiler < Barber::Precompiler

      def ember_template_precompiler
        @ember ||= File.new(::Ember::Source.bundled_path_for("ember-template-compiler.js"))
      end

      def precompiler
        @precompiler = File.new(File.expand_path("../../javascripts/ember_precompiler.js", __FILE__))
      end

      def sources
        [precompiler, handlebars, ember_template_precompiler]
      end
    end
  end
end
