(function() {
  var MenuView = Backbone.View.extend({
    className: 'menu_view',

    template: 'menu.html',

    render: function() {
      var template = BH.Lib.Template.fetch(this.template);
      var html = Mustache.to_html(template, this.getI18nValues());
      this.$el.html(html);
      return this;
    },

    select: function(selector) {
      this.$('.menu > *').removeClass('selected');
      this.$(selector).parent().addClass('selected');
    },

    getI18nValues: function() {
      return BH.Chrome.I18n.t(['settings_link', 'devices_link', 'search_link']);
    }
  });

  BH.Views.MenuView = MenuView;
})();
