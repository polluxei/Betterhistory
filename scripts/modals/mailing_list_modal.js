(function() {
   var MailingListModal = BH.Modals.Base.extend({
    className: 'mailing_list_view',
    template: 'mailing_list.html',

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

  MailingListModal.prompt = function(callback) {
    var chromeSync = new ChromeSync();
    var properties = ['mailingListPromptTimer', 'mailingListPromptSeen'];
    chromeSync.get(properties, function(data) {
      var mailingListPromptTimer = data.mailingListPromptTimer || 5,
          mailingListPromptSeen = data.mailingListPromptSeen;

      if(!mailingListPromptSeen) {
        if(mailingListPromptTimer == 1) {
          callback();
          chromeSync.remove('mailingListPromptTimer');
          chromeSync.save({mailingListPromptSeen: true});
        } else {
          chromeSync.save({mailingListPromptTimer: (mailingListPromptTimer - 1)});
        }
      }
    });
  };

  BH.Modals.MailingListModal = MailingListModal;
})();
