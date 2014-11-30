(function() {
  var MailingList = function(options) {
    this.syncStore = options.syncStore;
  };

  MailingList.prototype.prompt = function(callback) {
    this.syncStore.get(['mailingListPromptTimer', 'mailingListPromptSeen'], function(data) {
      var mailingListPromptTimer = data.mailingListPromptTimer || 5;
      var mailingListPromptSeen = data.mailingListPromptSeen;
      if(!mailingListPromptSeen) {
        if(mailingListPromptTimer == 1) {
          callback();
          this.syncStore.remove('mailingListPromptTimer');
          this.syncStore.set({mailingListPromptSeen: true});
        } else {
          this.syncStore.set({mailingListPromptTimer: (mailingListPromptTimer - 1)});
        }
      }
    });
  };

  BH.Init.MailingList = MailingList;
})();
