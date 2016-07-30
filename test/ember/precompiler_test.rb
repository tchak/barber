require 'test_helper'

class EmberPrecompilerTest < Minitest::Test
  def test_calls_the_ember_handlebars_precompiler
    result = compile "Hello {{name}}"
    assert result
    assert_match %r{data\.buffer|isHTMLBars: true|"revision": "Ember@}, result
  end

  def test_is_a_precompiler
    assert Barber::Ember::Precompiler < Barber::Precompiler,
      "Ember precompile should inherit from Barber::Precompiler"
  end

  def test_compiler_version
    assert_match %r{ember:}, Barber::Ember::Precompiler.compiler_version
  end

  def test_ember_template_compiler_path
    assert Barber::Ember::Precompiler.respond_to?(:ember_template_compiler_path=)
  end

  def test_ember_template_compiler_path_is_configurable
    compiler = Barber::Ember::Precompiler.new

    compiler.ember_template_compiler_path = File.expand_path('../../fixtures/ember-template-compiler.js', __FILE__)

    assert_match %r{ember:1\.11\.0}, compiler.compiler_version
  end

  def test_for_handlebars_anavailable
    if  Gem::Version.new(Ember::VERSION) < Gem::Version.new('1.10')
      skip "This ember-source (#{Ember::VERSION}) is too old to assert without Handlebars."
    end

    custom_compiler = Class.new Barber::Ember::Precompiler do
      # Stub for non-handlebars environment
      def self.handlebars_available?
        false
      end
    end

    assert_match %r{function\(\)}, custom_compiler.compile('{{hello}}')
  end

  private

  def compile(template)
    Barber::Ember::Precompiler.compile template
  end
end
