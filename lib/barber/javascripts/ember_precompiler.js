var exports = this.exports || {};

function require() {
  // ember-template-compiler only requires('handlebars')
  return Handlebars;
}

// Precompiler
var Barber = {
  precompile: function(string) {
    return exports.precompile(string).toString();
  }
};


