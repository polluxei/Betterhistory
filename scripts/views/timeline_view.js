(function() {
  var defaultData = _.range(0, 24).map(function(i) {
    return {label: i, data: 0};
  });

  var TimelineView = BH.Views.MainView.extend({
    template: 'timeline.html',

    events: {
      'click a.date': 'onDateClicked',
      'click a.next': 'onNextClicked',
      'click a.previous': 'onPreviousClicked'
    },

    initialize: function() {
      this.state = new Backbone.Model({
        startDate: moment(new Date()).startOf('day').toDate()
      });

      this.state.on('change:startDate', this.onStartDateChanged, this);
      this.collection.on('reset', this.onCollectionReset, this);
    },

    render: function() {
      this.$el.html('');

      var timelinePresenter = new BH.Presenters.Timeline(this.model.toJSON());
      var template = BH.Lib.Template.fetch(this.template);
      var properties = timelinePresenter.timeline(this.state.get('startDate'));
      this.$el.append(Mustache.to_html(template, properties));

      return this;
    },

    onCollectionReset: function() {
      var presenter = new BH.Presenters.VisitsPresenter();
      var visitsByHour = presenter.visitsByHour(this.collection.toJSON(), {rejectEmptyHours: false});
      var data = _.map(visitsByHour, function(hour) {
        return {label: hour.hour, data: hour.visits.length};
      });

      if(this.visualization) {
        this.visualization.update(data, {duration: 500});
      } else {
        this.visualization = new BH.Lib.Visualization().lineChart('#day_visualization', data);
      }
    },

    onStartDateChanged: function() {
      this.render();
    },

    onDateClicked: function(ev) {
      this.$('a').removeClass('selected');
      $(ev.currentTarget).addClass('selected');

      if(this.visualization) {
        this.visualization.update(defaultData, {duration: 250});
      }
    },

    onNextClicked: function(ev) {
      ev.preventDefault();

      if(!$(ev.currentTarget).hasClass('disabled')) {
        var date = moment(this.state.get('startDate')).add('days', 7);
        this.state.set({startDate: date.startOf('day').toDate()});
      }
    },

    onPreviousClicked: function(ev) {
      ev.preventDefault();

      if(!$(ev.currentTarget).hasClass('disabled')) {
        var date = moment(this.state.get('startDate')).subtract('days', 7);
        this.state.set({startDate: date.startOf('day').toDate()});
      }
    }
  });

  BH.Views.TimelineView = TimelineView;
})();
