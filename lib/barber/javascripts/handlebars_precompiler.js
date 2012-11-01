// Precompiler
var Barber = {
  precompile: function(string) {
    return Handlebars.precompile(string).toString();
  }
};
