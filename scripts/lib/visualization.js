(function() {
  var Visualization = function() {

  };

  Visualization.prototype.lineChart = function(id, data, options) {
    options = _.defaults(options || {}, {
      width: 738,
      height: 20
    });

    var x = d3.time.scale()
      .range([0, options.width]);

    var y = d3.scale.linear()
      .range([options.height, 0]);

    calculateDomain(data, x, y);

    var area = d3.svg.area()
      .interpolate("basis")
      .x(function(d) { return x(d.label); })
      .y0(options.height)
      .y1(function(d) { return y(d.data); });

    var line = d3.svg.line()
      .interpolate("basis")
      .x(function(d) { return x(d.label); })
      .y(function(d) { return y(d.data); });

    var svg = d3.select(id).append("svg")
      .attr("width", options.width)
      .attr("height", options.height)
      .append("g")
      .attr("transform", "translate(0,0)")

    var hoverLineXOffset = $(id).offset().left;
    var hoverLineYOffset = $(id).offset().top;

    $(id).mousemove(function(event) {
      var mouseX = event.pageX - hoverLineXOffset;
      var mouseY = event.pageY - hoverLineYOffset;

      console.log(mouseX);

      hoverLine.attr("x1", mouseX).attr("x2", mouseX)
    })

    var hoverLineGroup = svg.append("svg:g")
      .attr("class", "hover-line");

    hoverLine = hoverLineGroup
      .append("svg:line")
      .attr("x1", 40).attr("x2", 10) // vertical line so same value on each
      .attr("y1", 0).attr("y2", 20); // top to bottom

    svg.selectAll('path.area')
      .data([data])
      .enter()
      .append("svg:path")
      .attr("class", "area")
      .attr("d", area);

    svg.selectAll('path.line')
      .data([data])
      .enter()
      .append("svg:path")
      .attr("class", "line")
      .attr("d", line);

    svg.selectAll('circle.point')
      .data(data)
      .enter()
      .append("circle")
      .attr("r", 1)
      .attr("cy", function(d) { return y(d.data); })
      .attr("cx", function(d) { return x(d.label); })
      .attr("class", function(d) { return "point empty"; });

    return {
      update: function(data, options) {
        calculateDomain(data, x, y);

        svg.selectAll("path.line")
          .data([data])
          .transition()
          .duration(options.duration)
          .attr("d", line);

        svg.selectAll("path.area")
          .data([data])
          .transition()
          .duration(options.duration)
          .attr("d", area);

        svg.selectAll("circle.point")
          .data(data)
          .transition()
          .duration(options.duration)
          .attr("cy", function(d) { return y(d.data); })
          .attr("cx", function(d) { return x(d.label); })
          .attr("class", function(d) { return "point empty"; });
      }
    };
  }

  var calculateDomain = function(data, x, y) {
    x.domain(d3.extent(data, function(d) { return d.label; }));
    y.domain(d3.extent(data, function(d) { return d.data; }));
  };

  BH.Lib.Visualization = Visualization;
})();
