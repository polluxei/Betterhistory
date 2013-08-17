_.extend(Backbone.Model.prototype, {
  sync: _.wrap(Backbone.Model.prototype.sync, function() {
    var args;
    args = Array.prototype.slice.call(arguments, 1);
    if (this.storeName) {
      var _this = this;
      if (args[0] === 'read') {
        BH.Lib.SyncStore.get(this.storeName, function(data) {
          args[2].success(data[_this.storeName] || {});
        });
      } else if (args[0] === 'create') {
        data = {};
        data[this.storeName] = this.toJSON();
        BH.Lib.SyncStore.set(data, function() {
          args[2].success(data[_this.storeName]);
        });
      }
    } else {
      return arguments[0].apply(this, args);
    }
  })
});
