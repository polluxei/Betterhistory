(function() {
  var PromptModal = BH.Modals.Base.extend({
    className: 'prompt_view modal',
    template: 'prompt.html',

    events: {
      'click .no': 'clickedNo',
      'click .yes': 'clickedYes'
    },

    initialize: function() {
      this.attachGeneralEvents();
    },

    render: function() {
      var properties = _.extend(this.getI18nValues(), this.model.toJSON());
      this.$el.html(this.renderTemplate(properties));
      return this;
    },

    clickedNo: function(ev) {
      ev.preventDefault();
      this.model.set({action: false});
    },

    clickedYes: function(ev) {
      ev.preventDefault();
      this.spin();
      this.model.set({action: true});
    },

    spin: function() {
      this.$el.addClass('loading');
    },

    getI18nValues: function() {
      return BH.Chrome.I18n.t([
        'prompt_delete_button',
        'prompt_cancel_button',
        'prompt_title'
      ]);
    }
  });

  BH.Modals.CreatePrompt = function(content) {
    var modal = new PromptModal({
      model: new Backbone.Model({content: content})
    });
    $('body').append(modal.render().el);
    return modal;
  };

})();
