module Barber
  module Ember
    class Precompiler < Barber::Precompiler

      class << self
        def ember_template_compiler_path=(path)
          instance.ember_template_compiler_path = path
        end
      end

      attr_reader :ember_template_compiler_path

      def initialize
        super

        self.ember_template_compiler_path = ::Ember::Source.bundled_path_for("ember-template-compiler.js")
      end

      def ember_template_compiler_path=(path)
        @ember = @ember_version = @context = nil

        @ember_template_compiler_path = path
      end

      def ember_template_precompiler
        @ember ||= File.new(@ember_template_compiler_path)
      end

      def precompiler
        @precompiler = File.new(File.expand_path("../../javascripts/ember_precompiler.js", __FILE__))
      end

      def sources
        super + [ember_template_precompiler]
      end

      def compiler_version
        compiler_version = []
        compiler_version << "ember:#{ember_version}"
        compiler_version << "handlebars:#{handlebars_version}" if handlebars_version

        compiler_version.join('/')
      end

      private

      def ember_version
        @ember_version ||= context.eval('typeof Ember !== "undefined" && Ember.VERSION') || '(none)'
      end

      def handlebars_version
        return @handlebars_version if defined?(@handlebars_version)

        @handlebars_version = context.eval('typeof require !== "undefined" && require("handlebars") && require("handlebars").VERSION');
      end
    end
  end
end
