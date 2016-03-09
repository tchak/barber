require 'test_helper'
require 'stringio'

class PrecompilerTest < Minitest::Test
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

    result = compile template
    assert result
  end

  def test_handles_multiline_coffeescript_strings
    result = compile template_with_multiline_coffeescript_strings
    assert result
  end

  def test_handles_coffeescript_strings_with_qoutes_in_helpers
    result = compile template_with_coffeescript_qoutes_in_helpers
    assert result
  end

  def test_handles_prescaped_JSON_strings
    result = compile template_with_prescaped_JSON_strings
    assert result
  end

  def test_handles_single_quoted_strings
    result = compile template_with_single_quoted_strings
    assert result
  end

  def test_sanitize_with_json_multiline_coffeescript_strings
    assert_raises JSON::ParserError do
      sanitize_with_json template_with_multiline_coffeescript_strings
    end
  end

  def test_sanitize_multiline_coffeescript_strings
    result = sanitize template_with_multiline_coffeescript_strings
    assert_equal sanitized_template_with_multiline_coffeescript_strings, result
  end

  def test_sanitize_prescaped_JSON_strings
    result = sanitize template_with_prescaped_JSON_strings
    assert result
  end

  def test_sanitize_with_regexp_multiline_coffeescript_strings
    result = sanitize_with_regexp template_with_multiline_coffeescript_strings
    assert_equal sanitized_template_with_multiline_coffeescript_strings, result
  end

  def test_sanitize_with_json_prescaped_JSON_strings
    result = sanitize_with_json template_with_prescaped_JSON_strings
    assert result
  end

  def test_handlebars_available_works
    assert Barber::Precompiler.handlebars_available?
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

  def test_for_handlebars_anavailable
    custom_compiler = Class.new Barber::Precompiler do
      # Stub for non-handlebars environment
      def self.handlebars_available?
        false
      end
    end

    assert_raises Barber::PrecompilerError do
      custom_compiler.compile('{{hello}}')
    end
  end

  def test_compiler_version
    assert_match %r{handlebars:}, Barber::Precompiler.compiler_version
  end

  private

  def compile(template)
    Barber::Precompiler.compile template
  end

  def sanitize_with_json(template)
    Barber::Precompiler.new.send :sanitize_with_json, template
  end

  def sanitize_with_regexp(template)
    Barber::Precompiler.new.send :sanitize_with_regexp, template
  end

  def sanitize(template)
    Barber::Precompiler.new.send :sanitize, template
  end

  def template_with_multiline_coffeescript_strings
    '<h2>{{unbound view.title}}</h2>\n<ul>\n  {{#each view.content}}\n    {{view view.resultItemView\n      contentBinding="this"\n      selectedItemBinding="view.selectedItem"}}\n  {{/each}}\n</ul>'
  end

  def template_with_coffeescript_qoutes_in_helpers
    '<li {{action showContextMenu this target=\"view\"}}Foo</li>'
  end

  def sanitized_template_with_multiline_coffeescript_strings
    "<h2>{{unbound view.title}}</h2>\n<ul>\n  {{#each view.content}}\n    {{view view.resultItemView\n      contentBinding=\"this\"\n      selectedItemBinding=\"view.selectedItem\"}}\n  {{/each}}\n</ul>"
  end

  def template_with_prescaped_JSON_strings
    '"<div class=\"comments\">\n  <div class=\"span5 offset1\">\n    {{#if view.comments.length}}\n    <ul class=\"comments-list unstyled\">\n      {{#each view.comments}}\n        {{view Radium.CommentView commentBinding=\"this\"}}\n      {{/each}}\n    </ul>\n    {{/if}}\n    {{#if view.isError}}\n      <p class=\"error\">Hmm, something wasn\'t done correctly. Try again?</p>\n    {{/if}}\n    <div style=\"clear: both\"></div>\n    {{view view.commentTextArea}}\n  </div>\n</div>\n"'
  end

  def template_with_single_quoted_strings
    "<h2>{{unbound view.title}}</h2>\n<ul>\n  {{#each view.content}}\n    {{view view.resultItemView\n      contentBinding='this'\n      selectedItemBinding='view.selectedItem'}}\n  {{/each}}\n</ul>"
  end
end
