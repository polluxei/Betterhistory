(function() {
  var insert = function(html) {
    $('.mainview').append(html);
  };

  var Cache = function(options) {
    this.settings = options.settings;
    this.expire();
  };

  Cache.prototype.expire = function() {
    this.cache = {};
  };

  Cache.prototype.view = function(name, args) {
    var nameToFunc = {
      devices: 'devicesView',
      visits: 'visitsView',
      search: 'searchView',
      settings: 'settingsView'
    };

    var methodName = nameToFunc[name];

    var view = this[methodName].apply(this, args);
    var isDifferentView = name != this.lastRequest;
    if(isDifferentView) {
      view.select();
    }
    this.lastRequest = name;

    return {view: view, transitioning: isDifferentView};
  };

  Cache.prototype.devicesView = function() {
    if(!this.cache.devices) {
      this.cache.devices = new BH.Views.DevicesView({
        collection: new Backbone.Collection()
      });

      insert(this.cache.devices.render().el);
    }

    return this.cache.devices;
  };

  Cache.prototype.visitsView = function(date) {
    if(!this.cache.visits) {
      this.cache.visits = new BH.Views.VisitsView({
        collection: new Backbone.Collection(),
        model: new Backbone.Model({date: date})
      });

      insert(this.cache.visits.render().el);
    }

    this.cache.visits.model.set({date: date});
    return this.cache.visits;
  };

  Cache.prototype.searchView = function() {
    if(!this.cache.search) {
      this.cache.search = new BH.Views.SearchView({
        model: new Backbone.Model(),
        collection: new Backbone.Collection()
      });

      insert(this.cache.search.render().el);
    }

    return this.cache.search;
  };


  Cache.prototype.settingsView = function() {
    if(!this.cache.settings) {
      this.cache.settings = new BH.Views.SettingsView({
        model: this.settings,
        state: this.state
      });

      insert(this.cache.settings.render().el);
    }

   return this.cache.settings;
  };

  BH.Views.Cache = Cache;
})();
