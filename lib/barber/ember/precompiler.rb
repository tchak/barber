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
        super + [ember_template_precompiler]
      end

      def compiler_version
        cache_key = "ember-source:#{::Ember::VERSION}"

        if handlebars_version
          "handlebars:#{handlebars_version}/#{cache_key}"
        else
          cache_key
        end
      end

      private

      def handlebars_version
        return @handlebars_version if defined?(@handlebars_version)

        @handlebars_version = context.eval('typeof require !== "undefined" && require("handlebars") && require("handlebars").VERSION');
      end
    end
  end
end
