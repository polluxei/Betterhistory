(function() {
  var SettingsView = BH.Views.MainView.extend({
    className: 'settings_view',

    template: 'settings.html',

    events: {
      'click .clear_history': 'clickedClearHistory',
      'click .credits': 'clickedCredits',
      'click #search_by_domain': 'clickedSearchByDomain',
      'click #search_by_selection': 'clickedSearchBySelection'
    },

    initialize: function() {
      this.on('selected', this.activateSocialLinks, this);
      this.model.on('change', this.modelChanged, this);
    },

    pageTitle: function() {
      return BH.Chrome.I18n.t('settings_title');
    },

    activateSocialLinks: function() {
      !(function(d, s, id) {
        var fjs, js;
        fjs = d.getElementsByTagName(s)[0];
        if (!d.getElementById(id)) {
          js = d.createElement(s);
          js.id = id;
          js.src = "https://platform.twitter.com/widgets.js";
          return fjs.parentNode.insertBefore(js, fjs);
        }
      })(document, "script", "twitter-wjs");

      window.___gcfg = {
        lang: BH.Chrome.I18n.t('google_plus_language')
      };

      (function() {
        var po, s;
        po = document.createElement('script');
        po.type = 'text/javascript';
        po.async = true;
        po.src = 'https://apis.google.com/js/plusone.js';
        s = document.getElementsByTagName('script')[0];
        return s.parentNode.insertBefore(po, s);
      })();
    },

    render: function() {
      var template = BH.Lib.Template.fetch(this.template);
      var html = Mustache.to_html(template, this.getI18nValues());
      this.$el.append(html);
      this.populateFields();
      return this;
    },

    populateFields: function() {
      this.$('#search_by_domain').prop('checked', this.model.get('searchByDomain'));
      this.$('#search_by_selection').prop('checked', this.model.get('searchBySelection'));
    },

    modelChanged: function() {
      new ChromeSync().save({settings: this.model.toJSON()});
    },

    clickedSearchByDomain: function(ev) {
      this.model.set({searchByDomain: $(ev.currentTarget).is(':checked')});

      var backgroundPage = chrome.extension.getBackgroundPage();
      var method = (this.model.get('searchByDomain') ? 'create' : 'remove');

      backgroundPage.pageContextMenu[method]();
    },

    clickedSearchBySelection: function(ev) {
      this.model.set({searchBySelection: $(ev.currentTarget).prop('checked')});

      var backgroundPage = chrome.extension.getBackgroundPage();
      var method = (this.model.get('searchBySelection') ? 'create' : 'remove');

      backgroundPage.selectionContextMenu[method]();
    },

    clickedClearHistory: function(ev) {
      ev.preventDefault();
      chrome.tabs.create({url:'chrome://settings/clearBrowserData'});
    },

    clickedCredits: function(ev) {
      ev.preventDefault();
      var creditsModal = new BH.Modals.CreditsModal();
      $('body').append(creditsModal.render().el);
      creditsModal.open();
    },

    getI18nValues: function() {
      var properties = BH.Chrome.I18n.t([
        'settings_title',
        'clearing_history_section_title',
        'clear_history_button',
        'right_click_options_section_title',
        'search_by_text_selection_label',
        'search_by_domain_label',
        'feedback_section_title',
        'spread_the_word_section_title',
        'leave_a_review',
        'twitter_template',
        'twitter_language',
        'mailing_list_link'
      ]);
      properties.i18n_credits_link = BH.Chrome.I18n.t('credits_link', [
        '<strong>',
        '</strong>'
      ]);
      properties.i18n_suggestions_bugs_comments = BH.Chrome.I18n.t('suggestions_bugs_comments', [
        '<a href="http://twitter.com/Better_History">',
        '</a>'
      ]);
      return properties;
    }
  });

  BH.Views.SettingsView = SettingsView;
})();
