// Precompiler
var Barber = {
  precompile: function(string) {
    if (typeof Handlebars === 'undefined') {
      throw '`Handlebars` is missing. `gem "handlebars-source"` is required in your `Gemfile`.';
    }
    return Handlebars.precompile(string).toString();
  }
};
