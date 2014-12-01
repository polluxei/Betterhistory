(function() {
  var Base = Backbone.View.extend({
    pulseClass: 'pulse',

    generalEvents: {
      'click .close-button': 'close',
      'click .overlay': 'overlayClicked'
    },

    attachGeneralEvents: function() {
      _.extend(this.events, this.generalEvents);
    },

    renderTemplate: function(json) {
      var template = BH.Lib.Template.fetch(this.template);
      var overlay = $(BH.Lib.Template.fetch('modal.html'));
      $('.page', overlay).append(Mustache.to_html(template, json));
      return overlay;
    },

    open: function() {
      $('body').append(this.render().el);
      this._globalBinds();
      $(window).trigger('resize');

      var _this = this;
      setTimeout(function() {
        _this.$('.overlay').removeClass('transparent');
        _this.trigger('open');
      }, 0);
    },

    overlayClicked: function() {
      this.$('.page').addClass('pulse');
      var _this = this;
      this.$('.page').on('webkitAnimationEnd', function() {
        _this.$('.page').removeClass('pulse');
      });
    },

    close: function() {
      this.$('.overlay').addClass('transparent');

      var _this = this;
      setTimeout(function() {
        _this.remove();
        _this.trigger('close:removed');
      }, 1000);

      this._globalUnbinds();
      this.trigger('close');
    },

    _globalBinds: function() {
      $(window).resize(this._updateHeight);
      $(window).keydown($.proxy(this._closeOnEscape, this));
    },

    _globalUnbinds: function() {
      $(window).unbind('resize');
      $(document).unbind('keydown');
    },

    _updateHeight: function() {
      this.$('.page').css({
        maxHeight: Math.min(0.9 * window.innerHeight, 640)
      });
    },

    _closeOnEscape: function(e) {
      if(e.keyCode == 27) {
        this.close();
      }
    }
  });

  BH.Modals.Base = Base;
})();
