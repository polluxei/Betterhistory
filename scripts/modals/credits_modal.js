(function() {
  var CreditsModal = BH.Modals.Base.extend({
    className: 'credits_view',
    template: 'credits.html',

    events: {
      'click .close': 'closeClicked'
    },

    initialize: function() {
      this.attachGeneralEvents();
    },

    render: function() {
      this.$el.html(this.renderTemplate(this.getI18nValues()));
      return this;
    },

    closeClicked: function(ev) {
      ev.preventDefault();
      this.close();
    },

    openClicked: function(ev) {
      ev.preventDefault();
      this.open();
    },

    getI18nValues: function() {
      var properties = BH.Chrome.I18n.t([
        'credits_title',
        'translators_heading',
        'spanish',
        'swedish',
        'german',
        'french',
        'italian',
        'hungarian',
        'chinese_simplified',
        'arabic',
        'polish',
        'portuguese',
        'russian',
        'slovak',
        'catalonian',
        'hindi',
        'vietnamese',
        'japanese',
        'romanian',
        'czech',
        'dutch',
        'latvian',
        'turkish',
        'translation_help_heading',
        'close_button'
      ]);
      properties.i18n_developed_by = BH.Chrome.I18n.t('developed_by', [
        '<a href="http://blog.milkshake-island.com/">',
        '</a>',
        'Roy Kolak'
      ]);
      properties.i18n_translation_instructions = BH.Chrome.I18n.t('translation_instructions', [
        'roy.kolak@gmail.com',
        '<a href="mailto:roy.kolak@gmail.com">',
        '</a>'
      ]);
      return properties;
    }
  });
  BH.Modals.CreditsModal = CreditsModal;
})();
