class BH.Models.Interval extends Backbone.Model
  findVisitById: (id) ->
    foundVisit = @get('visits').get(id)
    return foundVisit if foundVisit?

    @get('visits').find (visit) =>
      if visit.get('visits')?
        foundVisit = visit.get('visits').get(id)
        return true if foundVisit?
    return foundVisit
