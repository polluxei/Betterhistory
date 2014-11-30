(function() {
  I18n = {
    t: function(key, replacements) {
      if(key instanceof Array) {
        var keys = key, lookup = {};
        keys.forEach(function(key) {
          lookup['i18n_' + key] = chrome.i18n.getMessage(key.toString());
        });
        return lookup;
      } else {
        return chrome.i18n.getMessage(key, replacements);
      }
    }
  };

  BH.Chrome.I18n = I18n;
})();
