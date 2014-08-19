# This file only contains additions to Zepto to add lesser-used functions
# from jQuery that we do actually need.

if this.Zepto
  do ($ = Zepto) ->

    # innerHeight & outerHeight are needed by <a plugin we use>
    #
    # outerHeight is documented at http://api.jquery.com/outerHeight/
    #
    # The below code based upon https://gist.github.com/1379704 by pamelafox.
    ioDim = (elem, Dimension, dimension, includeBorder, includeMargin) ->
      if elem
        # "Note that .height() will always return the content height,
        # regardless of the value of the CSS box-sizing property."
        #                            -- http://api.jquery.com/height/
        size = elem[dimension]()
        # Thus, `size` is now our contentHeight; no matter our box-sizing
        # mode, we need to add padding and border width to our size.

        sides =
          width: ["left", "right"]
          height: ["top", "bottom"]

        sides[dimension].forEach (side) ->
          size += parseInt(elem.css("padding-#{side}"), 10)
          size += parseInt(elem.css("border-#{side}-width"), 10) if includeBorder
          size += parseInt(elem.css("margin-#{side}"), 10)  if includeMargin

        size
      else
        null
    ["width", "height"].forEach (dimension) ->
      Dimension = dimension.replace(/./, (m) ->
        m[0].toUpperCase()
      )

      $.fn["inner" + Dimension] ||= (includeMargin) ->
        ioDim(this, Dimension, dimension, false, includeMargin)

      $.fn["outer" + Dimension] ||= (includeMargin) ->
        ioDim(this, Dimension, dimension, true, includeMargin)

    # .detach() is like .remove() but it keeps data & events intact;
    # it lets you move something in the dom.
    # On http://api.jquery.com/detach/ someone indicates that this is
    # basically a .clone(true) follewed by a .remove.
    $.fn.detach ||= (selector) ->
      set = this
      if selector?
        set = set.filter selector
      cloned = set.clone(true)
      set.remove()
      return cloned
