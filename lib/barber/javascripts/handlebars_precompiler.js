// Precompiler
var Barber = {
  precompile: function(string) {
    return Handlebars.precompile.call(null, string).toString();
  }
};
