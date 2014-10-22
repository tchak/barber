var exports = this.exports || {};
var module = this.module || {exports: null};

function require() {
  // ember-template-compiler only requires('handlebars')
  return module.exports || Handlebars;
}

// Precompiler
var Barber = {
  precompile: function(string) {
    return exports.precompile(string, false).toString();
  }
};
