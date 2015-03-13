var exports = this.exports || {};
var module = this.module || {exports: null};

function require() {
  // ember-template-compiler only requires which 'handlebars' or 'htmlbars'.
  return module.exports || Handlebars;
}

// Precompiler
var Barber = {
  precompile: function(string) {
    var Compiler = exports.precompile ? exports : require(/* ember-template-compiler */);

    return Compiler.precompile(string, false).toString();
  }
};
