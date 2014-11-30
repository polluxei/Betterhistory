(function() {
  var VisitsResultsView = Backbone.View.extend({
    template: BH.Templates.visits_results,

    events: {
      'click .download': 'downloadClicked',
      'click .delete_hour': 'deleteHourClicked',
      'click .delete_visit': 'deleteVisitClicked',
      'click .delete_download': 'deleteDownloadClicked',
      'click .visit > a': 'visitClicked',
      'click .hours a': 'hourClicked'
    },

    render: function() {
      var properties = this.getI18nValues();
      var presenter = new BH.Presenters.VisitsPresenter();
      var visitsByHour = presenter.visitsByHour(this.collection.toJSON());
      var hours = presenter.hoursDistribution(this.collection.toJSON());

      if(this.collection.length > 0) {
        var date = new Date(this.model.get('date'));
        properties.history = {
          visitsByHour: visitsByHour.reverse(),
          date: date.toLocaleDateString('en'),
          day: moment(date).format('dddd'),
          hours: hours
        };
      }

      html = Mustache.to_html(this.template, properties);

      this.$el.html(html);

      document.body.scrollTop = 0;

      this.show();
      this.inflateDates();
      this.inflateDownloadIcons();

      // Mark first available hour as selected
      this.$('.controls.hours a:not(.disabled)').eq(0).addClass('selected');

      window.analyticsTracker.dayActivityDownloadCount(this.$('.visits a.download').length);
      window.analyticsTracker.dayActivityVisitCount(this.$('.visits a.site').length);


      var lastId = null;
      var topMenu = this.$('.hours');
      var topMenuHeight = topMenu.outerHeight();
      var menuItems = topMenu.find("a");
      var scrollItems = menuItems.map(function() { $($(this).attr("href")); });

      $(window).scroll(function() {
        // Get container scroll position
        var fromTop = document.body.scrollTop;

        // Get id of current scroll item
        var cur = [];
        scrollItems.map(function(el) {
          var offsetTop = el.getBoundingClientRect().top + document.body.scrollTop - 205;
          if(offsetTop < fromTop) {
            cur.push(el);
          }
        });

        // Get the id of the current element
        if(cur[cur.length - 1]) {
          var id = cur[cur.length - 1].id;
          if(lastId !== id) {
            lastId = id;

            // Set/remove active class
            menuItems.removeClass("selected");
            menuItems.filter("[href='#" + id + "']").addClass("selected");
          }
          return;
        }
      });

      return this;
    },

    resetRender: function() {
      this.hide();
      this.$('.visits_content').html('');
    },

    show: function() {
      this.$el.removeClass('disappear');
    },

    hide: function() {
      this.$el.addClass('disappear');
    },

    inflateDates: function() {
      var _this = this;
      $('.time').each(function(i, el) {
        var model = _this.collection.at(i);
        timestamp = model.get('lastVisitTime') || model.get('startTime');
        $(el).text(new Date(timestamp).toLocaleTimeString(BH.lang));
      });
    },

    inflateDownloadIcons: function() {
      var callback = function(el, uri) {
        $(el).find('.description').css({backgroundImage: "url(" + uri + ")"});
      };

      $('.download').each(function(i, el) {
        downloadId = parseInt($(el).data('download-id'), 10);
        chrome.downloads.getFileIcon(downloadId, {}, function(uri) {
          callback(el, uri);
        });
      });
    },

    visitClicked: function(ev) {
      if($(ev.target).hasClass('search_domain')) {
        ev.preventDefault();
        router.navigate($(ev.target).attr('href'), {trigger: true});
      }
    },

    hourClicked: function(ev) {
      ev.preventDefault();
      $el = $(ev.currentTarget);

      window.analyticsTracker.hourClick($el.data('hour'));

      var $hour = $($el.attr('href'))[0];

      document.body.scrollTop = $hour.getBoundingClientRect().top + document.body.scrollTop - 155;
    },

    downloadClicked: function(ev) {
      ev.preventDefault();
      var $el = $(ev.currentTarget);
      var downloadId = parseInt($el.data('download-id'), 10);
      chrome.downloads.show(downloadId);
    },

    deleteHourClicked: function(ev) {
      ev.preventDefault();
      var hour = $(ev.currentTarget).data('hour');
      this.promptToDeleteHour(hour);
    },

    deleteVisitClicked: function(ev) {
      ev.preventDefault();
      var $el = $(ev.currentTarget);
      analyticsTracker.visitDeletion();
      Historian.deleteUrl($el.data('url'), function() {
        $el.parent('.visit').remove();
      });
    },

    deleteDownloadClicked: function(ev) {
      ev.preventDefault();
      var $el = $(ev.currentTarget);
      analyticsTracker.downloadDeletion();
      Historian.deleteDownload($el.data('url'), function() {
        $el.parent('.visit').remove();
      });
    },

    promptToDeleteHour: function(hour) {
      var date = new Date(this.model.get('date'));
      date.setHours(hour);
      date.setSeconds(0);
      date.setMinutes(0);
      var timestamp = date.toLocaleString(BH.lang);
      var promptMessage = BH.Chrome.I18n.t('confirm_delete_all_visits', [timestamp]);
      this.promptView = BH.Modals.CreatePrompt(promptMessage);
      this.promptView.open();
      var _this = this;
      this.promptView.model.on('change', function(prompt) {
        _this.promptAction(prompt, hour);
      }, this);
    },

    promptAction: function(prompt, hour) {
      if(prompt.get('action')) {
        window.analyticsTracker.hourDeletion();
        var date = new Date(this.model.get('date'));
        var dayHistorian = new Historian.Day(date);
        dayHistorian.destroyHour(hour, function() {
          window.location.reload();
        });
      } else {
        this.promptView.close();
      }
    },

    getI18nValues: function() {
      return BH.Chrome.I18n.t([
        'prompt_delete_button',
        'delete_time_interval_button',
        'no_visits_found',
        'expand_button',
        'collapse_button',
        'search_by_domain',
        'delete_all_visits_for_filter_button'
      ]);
    }
  });

  BH.Views.VisitsResultsView = VisitsResultsView;
})();
