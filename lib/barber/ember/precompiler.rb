module Barber
  module Ember
    class Precompiler < Barber::Precompiler
      def ember_path
        @ember_path ||= File.new(File.expand_path("../../javascripts/ember.js", __FILE__))
      end

      def precompiler_path
        @precompiler_path = File.new(File.expand_path("../../javascripts/ember_precompiler.js", __FILE__))
      end

      def sources
        super + [File.new(ember_path), File.new(precompiler_path)]
      end
    end
  end
end
