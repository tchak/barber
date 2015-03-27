require 'test_helper'

class EmberPrecompilerTest < MiniTest::Unit::TestCase
  def test_calls_the_ember_handlebars_precompiler
    result = compile "Hello {{name}}"
    assert result
    assert_match /data\.buffer|isHTMLBars: true/, result
  end

  def test_is_a_precompiler
    assert Barber::Ember::Precompiler < Barber::Precompiler,
      "Ember precompile should inherit from Barber::Precompiler"
  end

  def test_compiler_version
    assert Barber::Ember::Precompiler.compiler_version
  end

  private

  def compile(template)
    Barber::Ember::Precompiler.compile template
  end
end
