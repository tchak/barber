require "barber/version"

require 'ember/source'

require "barber/precompiler"
require "barber/precompilers"

require "barber/ember/precompiler"
require "barber/ember/precompilers"

module Barber
  class PrecompilerError < StandardError
    def initialize(template, error)
      @template, @error = template, error
    end

    def to_s
      "Pre compilation failed for: #{@template}\n. Compiler said: #{@error}"
    end
  end
end
