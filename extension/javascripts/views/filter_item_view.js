FilterItemView = Backbone.View.extend({
  className: 'filter_item_view selectable',
  tagNase: 'ul',

  initialize: function() {
    this.model.bind('count', this.count, this);
  },

  render: function() {
    $(this.el).append(ich.filterItem(this.model.presenter()));
    return this;
  },

  count: function(count) {
    if(count.count === 0) $('a', this.el).addClass('empty');
  }
});