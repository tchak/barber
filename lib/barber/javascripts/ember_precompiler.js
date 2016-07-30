var exports = this.exports || {};
var module = this.module || {exports: null};

function require() {
  // ember-template-compiler only requires which 'handlebars' or 'htmlbars'.

  // Ember 1.9
  if (exports.precompile) {
    return exports;
  }
  // Ember 2.7 or later
  if (typeof Ember !== 'undefined') {
    return Ember.Handlebars;
  }
  // Ember >= 1.10, < 2.7
  if (module.exports) {
    return module.exports;
  }
  // Older Ember
  if (typeof Handlebars !== 'undefined') {
    return Handlebars;
  }

  throw '`ember-template-compiler` is missing.';
}

// Precompiler
var Barber = {
  precompile: function(string, options) {
    var Compiler = require(/* ember-template-compiler */);

    return Compiler.precompile(string, options).toString();
  }
};
