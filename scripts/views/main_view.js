(function() {
  var MainView = Backbone.View.extend({
    select: function() {
      $('.mainview > *').removeClass('selected');
      $('.mainview > *').css({display: 'block'});

      var _this = this;
      setTimeout(function() {
        _this.$el.addClass('selected');
        $('.mainview > *:not(.selected)').css({display: 'none'});
      }, 0);

      if(this.pageTitle) {
        var element = $('<div/>');
        var cleanTitle = $(element).html(this.pageTitle()).text();
        document.title = cleanTitle + " - Better History";
      }

      this.trigger('selected');
      return this;
    },

    onRemoveSearchFilterClick: function(ev) {
      ev.preventDefault();
      this.$('.corner .tags').hide();
      this.$('.corner input').data('filter', false);
    },

    onSearchTyped: function(ev) {
      var term = this.trimedSearchTerm();
      var $el = $(ev.currentTarget);
      if(ev.keyCode === 13 && term !== '') {
        router.navigate("search/" + term, true);
      }
    },

    onSearchBlurred: function() {
      this.$('.search').val(this.trimedSearchTerm());
    },

    trimedSearchTerm: function() {
      return $.trim(this.$('.search').val());
    },

    assignTabIndices: function(selector) {
      $('*').removeAttr('tabindex');
      this.$('input.search').attr('tabindex', 1);
      this.$(selector).each(function(i) {
        $(this).attr('tabindex', i + 2);
      });
      this.$('.search').focus();
    },

    browserFeatureNotSupported: function() {
      this.$('.content').html('Sorry, this is not supported in your browser. We recommend using the latest <a href="https://www.google.com/chrome/browser/" target="_blank">Chrome</a>.');
    }
  });

  BH.Views.MainView = MainView;
})();
