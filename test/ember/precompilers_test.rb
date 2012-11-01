require 'test_helper'

class EmberPrecompilersTest < MiniTest::Unit::TestCase
  def template ; "{{hello}}" ; end
  def compiled_template ; "function()" ; end

  def test_precompiles_inline_templates
    Barber::Ember::Precompiler.expects(:compile).with(template).returns(compiled_template)

    result = Barber::Ember::InlinePrecompiler.call(template)
    assert_equal "Ember.Handlebars.template(#{compiled_template})", result
  end

  def test_precompiles_template_files
    Barber::Ember::Precompiler.expects(:compile).with(template).returns(compiled_template)

    result = Barber::Ember::FilePrecompiler.call(template)
    assert_equal "Ember.Handlebars.template(#{compiled_template});", result
  end
end
