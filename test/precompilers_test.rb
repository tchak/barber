require 'test_helper'

class PrecompilersTest < Minitest::Test
  def template ; "{{hello}}" ; end
  def compiled_template ; "function()" ; end
  def compile_option ; {moduleName: "hello"} ; end

  def test_precompiles_inline_templates
    Barber::Precompiler.expects(:compile).with(template, nil).returns(compiled_template)

    result = Barber::InlinePrecompiler.call(template)
    assert_equal "Handlebars.template(#{compiled_template})", result
  end

  def test_precompiles_inline_templates_with_compile_option
    Barber::Precompiler.expects(:compile).with(template, compile_option).returns(compiled_template)

    result = Barber::InlinePrecompiler.call(template, compile_option)
    assert_equal "Handlebars.template(#{compiled_template})", result
  end

  def test_precompiles_template_files
    Barber::Precompiler.expects(:compile).with(template, nil).returns(compiled_template)

    result = Barber::FilePrecompiler.call(template)
    assert_equal "Handlebars.template(#{compiled_template});", result
  end

  def test_precompiles_template_files_with_option
    Barber::Precompiler.expects(:compile).with(template, compile_option).returns(compiled_template)

    result = Barber::FilePrecompiler.call(template, compile_option)
    assert_equal "Handlebars.template(#{compiled_template});", result
  end
end
