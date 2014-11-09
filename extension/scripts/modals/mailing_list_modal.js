(function() {
   var MailingListModal = BH.Modals.Base.extend({
    className: 'mailing_list_view',
    template: BH.Templates.mailing_list,

    events: {
      'click .close': 'closeClicked',
      'click #join_mailing_list': 'joinMailingListClicked'
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

    joinMailingListClicked: function() {
      this.close();
    },

    getI18nValues: function() {
      return BH.Chrome.I18n.t([
        'close_button',
        'mailing_list_title',
        'mailing_list_description',
        'mailing_list_link',
        'mailing_list_promise',
        'leave_a_review'
      ]);
    }
  });

  BH.Modals.MailingListModal = MailingListModal;
})();
