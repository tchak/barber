require 'test_helper'
require 'stringio'

class PrecompilerTest < MiniTest::Unit::TestCase
  def test_returns_a_template
    result = compile "Hello {{name}}"
    assert result
  end

  def test_compiles_nil_template
    result = compile nil
    assert result
  end

  def test_compiles_templates_with_quotes
    template = <<-hbs
    <div class="calendar">
      <a {{action switchToNextYear target="view"}}>{{view.nextYear}}</a>
    </div>

    {{view Radium.RangeChangerView}}
    hbs

    result = compile template
    assert result
  end

  def test_handles_multiline_coffeescript_strings
    template = '<h2>{{unbound view.title}}</h2>\n<ul>\n  {{#each view.content}}\n    {{view view.resultItemView\n      contentBinding="this"\n      selectedItemBinding="view.selectedItem"}}\n  {{/each}}\n</ul>'

    sanitized = "<h2>{{unbound view.title}}</h2>\n<ul>\n  {{#each view.content}}\n    {{view view.resultItemView\n      contentBinding=\"this\"\n      selectedItemBinding=\"view.selectedItem\"}}\n  {{/each}}\n</ul>"

    result = sanitize template
    assert_equal sanitized, result
  end

  def test_handles_prescaped_JSON_strings
    template = '"<div class=\"comments\">\n  <div class=\"span5 offset1\">\n    {{#if view.comments.length}}\n    <ul class=\"comments-list unstyled\">\n      {{#each view.comments}}\n        {{view Radium.CommentView commentBinding=\"this\"}}\n      {{/each}}\n    </ul>\n    {{/if}}\n    {{#if view.isError}}\n      <p class=\"error\">Hmm, something wasn\'t done correctly. Try again?</p>\n    {{/if}}\n    <div style=\"clear: both\"></div>\n    {{view view.commentTextArea}}\n  </div>\n</div>\n"'

    result = compile template
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

  def sanitize(template)
    Barber::Precompiler.new.send :sanitize, template
  end
end
