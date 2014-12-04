(function() {
  var VisitView = Backbone.View.extend({
    className: 'visit_view',
    template: 'visit.html',

    render: function() {
      var template = BH.Lib.Template.fetch(this.template);
      var html = Mustache.to_html(this.template, this.model.toJSON());
      this.$el.html(html);
      return this;
    }
  });

  BH.Views.VisitView = VisitView;
})();
