_.extend(Backbone.Model.prototype, {
  sync: _.wrap(Backbone.Model.prototype.sync, function() {
    var args;
    args = Array.prototype.slice.call(arguments, 1);
    if (this.storeName) {
      if (args[0] === 'read') {
        if (localStorage[this.storeName]) {
          return args[2].success(localStorage[this.storeName]);
        }
      } else if (args[0] === 'create') {
        localStorage[this.storeName] = JSON.stringify(this);
        return args[2].success(localStorage[this.storeName]);
      }
    } else {
      return arguments[0].apply(this, args);
    }
  })
});
