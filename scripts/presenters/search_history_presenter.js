(function() {
  var wrapMatchInProperty = function(regExp, property) {
    if(!property) {
      return;
    }
    match = property.match(regExp);
    if(match) {
      return property.replace(regExp, '<span class="match">' + match + '</span>');
    } else {
      return property;
    }
  };

  var markMatches = function(visit, query) {
    // Don't try and highlight regex matches
    if(query.match(/^\/.*\/$/)) {
      visit.name = visit.title;
      visit.location = visit.url;
    } else {
      query.split(' ').forEach(function(term) {
        regExp = new RegExp(term, "i");
        visit.name = wrapMatchInProperty(regExp, visit.title);
        visit.location = wrapMatchInProperty(regExp, visit.url);
      });
    }

    return visit;
  };

  var SearchHistoryPresenter = function(visits, query) {
    this.visits = visits;
    this.query = query;
  };

  SearchHistoryPresenter.prototype.history = function(start, end) {
    var out = [],
        _this = this;

    if(typeof start !== 'undefined' && typeof end !== 'undefined') {
      _.range(start, end).forEach(function(i) {
        if(_this.visits[i]) {
          out.push(markMatches(_this.visits[i], _this.query));
        }
      });
    } else {
      this.visits.forEach(function(visit) {
        out.push(markMatches(visit, _this.query));
      });
    }
    return out;
  };

  BH.Presenters.SearchHistoryPresenter = SearchHistoryPresenter;
})();
