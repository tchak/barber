require 'test_helper'
require 'stringio'

class PrecompilerTest < MiniTest::Unit::TestCase
  def test_returns_a_template
    result = compile "Hello {{name}}"
    assert result
  end

  def test_compiles_templates_with_quotes
    template = <<-hbs
    <div class="calendar">
      <a {{action switchToNextYear target="view"}}>{{view.nextYear}}</a>
    </div>

    {{view Radium.RangeChangerView}}
    hbs

    result = compile JSON.dump({:template => template})['template']
    assert result
  end

  def test_raises_an_error_on_bad_templates
    assert_raises Barber::PrecompilerError do
      compile "Hello {{"
    end
  end

  def test_has_an_easy_to_customize_public_interface
    custom_compiler = Class.new Barber::Precompiler do
      def sources
        [StringIO.new(compiler_source)]
      end

      def compiler_source
        %Q|var Barber = { precompile: function(string) { return "Foo"; }};|
      end
    end

    assert_equal "Foo", custom_compiler.compile("{{hello}}")
  end

  private
  def compile(template)
    Barber::Precompiler.compile template
  end
end
