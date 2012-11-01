require "barber/version"
require "barber/handlebars/precompiler"
require "barber/handlebars/compilers"
require "barber/ember/precompiler"
require "barber/ember/compilers"

module Barber
  class PrecompilerError < StandardError
    def initialize(template, error)
      @template, @error = @template, error
    end

    def to_s
      "Pre compilation failed for: #{@template}\n. Compiler said: #{@error}"
    end
  end
end
