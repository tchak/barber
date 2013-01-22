var exports = this.exports || {};

// Precompiler
var Barber = {
  precompile: function(string) {
    return exports.precompile(string).toString();
  }
};
