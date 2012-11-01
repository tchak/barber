require 'test_helper'

class EmberPrecompilerTest < MiniTest::Unit::TestCase
  def test_calls_the_ember_handlebars_precompiler
    result = compile "Hello {{name}}"
    assert result
    assert_match result, /Ember\.Handlebars/
  end

  def test_is_a_precompiler
    assert Barber::Ember::Precompiler < Barber::Precompiler, 
      "Ember precompile should inherit from Barber::Precompiler"
  end

  def compile(template)
    Barber::Ember::Precompiler.compile template
  end
end
