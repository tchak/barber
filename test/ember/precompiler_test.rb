require 'test_helper'

class EmberPrecompilerTest < MiniTest::Unit::TestCase
  def test_calls_the_ember_handlebars_precompiler
    result = compile "Hello {{name}}"
    assert result
    assert_match /data\.buffer|isHTMLBars: true|"revision": "Ember@/, result
  end

  def test_is_a_precompiler
    assert Barber::Ember::Precompiler < Barber::Precompiler,
      "Ember precompile should inherit from Barber::Precompiler"
  end

  def test_compiler_version
    assert_match /ember:/, Barber::Ember::Precompiler.compiler_version
  end

  def test_ember_template_compiler_path
    assert Barber::Ember::Precompiler.respond_to?(:ember_template_compiler_path=)
  end

  def test_ember_template_compiler_path_is_configurable
    compiler = Barber::Ember::Precompiler.new

    compiler.ember_template_compiler_path = File.expand_path('../../fixtures/ember-template-compiler.js', __FILE__)

    assert_match /ember:1\.11\.0/, compiler.compiler_version
  end

  private

  def compile(template)
    Barber::Ember::Precompiler.compile template
  end
end
