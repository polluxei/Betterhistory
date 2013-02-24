(function() {
  var halt = function(message) {
    objectName = this.constructor.name;
    throw new Error(objectName + ": " + message);
  };

  BH.Base.prototype.halt = halt;
  Backbone.Model.prototype.halt = halt;
  Backbone.View.prototype.halt = halt;
  Backbone.Collection.prototype.halt = halt;
})();
