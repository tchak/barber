module Barber
  module Ember
    class Precompiler < Barber::Precompiler
      def ember
        @ember ||= File.new(File.expand_path("../../javascripts/ember.js", __FILE__))
      end

      def precompiler
        @precompiler = File.new(File.expand_path("../../javascripts/ember_precompiler.js", __FILE__))
      end

      def sources
        super << ember
      end
    end
  end
end
