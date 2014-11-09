(function() {
  var TimelineView = BH.Views.MainView.extend({
    template: BH.Templates.timeline,

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
    },

    render: function() {
      this.$el.html('');

      var timelinePresenter = new BH.Presenters.Timeline(this.model.toJSON());
      var properties = timelinePresenter.timeline(this.state.get('startDate'));
      this.$el.append(Mustache.to_html(this.template, properties));

      return this;
    },

    onStartDateChanged: function() {
      this.render();
    },

    onDateClicked: function(ev) {
      this.$('a').removeClass('selected');
      $(ev.currentTarget).addClass('selected');
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
