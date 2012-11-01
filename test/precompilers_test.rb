require 'test_helper'

class PrecompilersTest < MiniTest::Unit::TestCase
  def template ; "{{hello}}" ; end
  def compiled_template ; "function()" ; end

  def test_precompiles_inline_templates
    Barber::Precompiler.expects(:compile).with(template).returns(compiled_template)

    result = Barber::InlinePrecompiler.call(template)
    assert_equal "Handlebars.template(#{compiled_template})", result
  end

  def test_precompiles_template_files
    Barber::Precompiler.expects(:compile).with(template).returns(compiled_template)

    result = Barber::FilePrecompiler.call(template)
    assert_equal "Handlebars.template(#{compiled_template});", result
  end
end
