(function() {
  var VisitView = Backbone.View.extend({
    className: 'visit_view',
    template: BH.Templates.visit,

    render: function() {
      var html = Mustache.to_html(this.template, this.model.toJSON());
      this.$el.html(html);
      return this;
    }
  });

  BH.Views.VisitView = VisitView;
})();
