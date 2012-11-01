require 'test_helper'

class PrecompilerTest < MiniTest::Unit::TestCase
  def test_returns_a_template
    result = compile "Hello {{name}}"
    assert result
  end

  def test_returns_a_ember_template
    result = compile_ember "Hello {{name}}"
    assert result
  end

  def test_compiles_templates_with_quotes
    template = <<-hbs
    <div class="calendar">
      <a {{action switchToNextYear target="view"}}>{{view.nextYear}}</a>
    </div>

    {{view Radium.RangeChangerView}}
    hbs

    result = compile JSON.dump(template)
    assert result
  end

  def test_compiles_ember_templates_with_quotes
    template = <<-hbs
    <div class="calendar">
      <a {{action switchToNextYear target="view"}}>{{view.nextYear}}</a>
    </div>

    {{view Radium.RangeChangerView}}
    hbs

    result = compile_ember JSON.dump(template)
    assert result
  end

  def test_raises_an_error_on_bad_templates
    assert_raises Barber::PrecompilerError do
      compile "Hello {{"
    end
  end

  def test_raises_an_error_on_bad_ember_templates
    assert_raises Barber::PrecompilerError do
      compile_ember "Hello {{"
    end
  end

  private
  def compile(template)
    Barber::Handlebars::Precompiler.compile template
  end

  def compile_ember(template)
    Barber::Ember::Precompiler.compile template
  end
end
