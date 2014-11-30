(function() {
  var DevicesListView = Backbone.View.extend({
    className: 'devices_list_view',

    template: BH.Templates.devices_list,

    events: {
      'click a': 'deviceClicked'
    },

    render: function() {
      presenter = new BH.Presenters.DevicesPresenter();
      var html = Mustache.to_html(this.template, presenter.deviceList(this.collection.toJSON()));
      this.$el.append(html);
      return this;
    },

    deviceClicked: function(ev) {
      ev.preventDefault();
      var $el = $(ev.currentTarget);

      window.analyticsTracker.deviceClick();

      this.$('.selected').removeClass('selected');
      $el.addClass('selected');

      this.model.set({name: $el.data('name')});
    }
  });

  BH.Views.DevicesListView = DevicesListView;
})();
