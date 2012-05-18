AppView = Backbone.View.extend({
  templateId: 'app',

  render: function() {
    this.$el.append(this.template(i18n.app()));

    $('.mainview').append(BH.views.settingsView.render().el);
    //$('.mainview').append(BH.views.searchView.render().el);
    this.collection.each(function(model) {
      $('.mainview').append(BH.views.weekViews[model.id].render().el);
    });

    $('.navbar', this.$el).append(BH.views.sidebarView.render().el);
    return this;
  }
});
