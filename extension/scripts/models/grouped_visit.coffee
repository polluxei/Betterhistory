class BH.Models.GroupedVisit extends Backbone.Model
  initialize: (attr) ->
    @visits = new BH.Collections.GroupedVisits(attr)
    @set
      host: @visits.at(0).domain()
      domain: @visits.at(0).domain()
      url: @visits.at(0).get('url')
      time: @visits.at(0).get('time')
      isGrouped: true
      visits: @visits
