moment.fn.past = function(input, val) {
  input = input.charAt(0).toUpperCase() + input.slice(1);
  var back = function (date, occurrences) {
    if(date.format('dddd') != input) {
      return back(date.subtract('days', 1), occurrences);
    } else {
      if(occurrences === 0) {
        return moment(date.id());
      } else {
        return back(date.subtract('days', 1), occurrences - 1);
      }
    }
  };
  return back(moment(this).lang('en'), val);
};

moment.fn.id = function() {
  return this.format('M-D-YY');
};
