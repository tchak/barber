module Barber
  module Ember
    class Precompiler < Barber::Handlebars::Precompiler
      class << self
        def ember_path
          File.expand_path("../javascripts/ember.js", __FILE__)
        end

        def precompiler_path
          File.expand_path("../javascripts/ember_precompiler.js", __FILE__)
        end

        def sources
          super << ember_path
        end
      end
    end
  end
end
