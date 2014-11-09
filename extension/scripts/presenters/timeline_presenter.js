(function() {

  var getLabel = function(date) {
    if(moment().startOf('day').isSame(date)) {
      return 'Today';
    }
    if(moment().subtract('days', 1).startOf('day').isSame(date)) {
      return 'Yesterday';
    }

    return date.format('dddd');
  };

  var getId = function(date) {
    if(moment().startOf('day').isSame(date)) {
      return 'today';
    }
    if(moment().subtract('days', 1).startOf('day').isSame(date)) {
      return 'yesterday';
    }

    return date.format('M-D-YY');
  };

  var Timeline = function(json) {
   this.json = json;
  };

  Timeline.prototype.timeline = function(startDate) {
    var _this = this;
    dates = _.map(_.range(0, 6), function(i) {
      var date = moment(startDate).startOf('day').subtract('days', i);
      return {
        label: getLabel(date),
        date: date.format('MMM Do'),
        selected: (date.isSame(moment(_this.json.date).startOf('day')) ? true : false),
        id: getId(date)
      };
    });

    return {
      dates: dates,
      nextButtonDisabled: dates[0].id == moment().format('M-D-YY')
    };
  };

  BH.Presenters.Timeline = Timeline;
})();
