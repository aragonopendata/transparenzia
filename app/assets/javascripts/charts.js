function by_place_graph(){
  var values = get_values_for_charts($('#by_place li'));
  bar_graphs(values, "#by_place svg");
}
function by_department_graph(){
  var values = get_values_for_charts($('#by_department li'));
  bar_graphs(values, "#by_department svg");
}
function by_tipology_graph(){
  var values = get_values_for_charts($('#by_tipology li'));
  bar_graphs(values, "#by_tipology svg");
}

function bar_graphs (values, svg_element) {
  var barHeight = 40;
  var barInterval = 20;
  var chartHeight = (barHeight + barInterval) * values.length;
  var chartWidth = 800;

  var chart = d3.select(svg_element)
     .attr("height", chartHeight+20)
     .attr("width", chartWidth)
     .append("g")
     .attr("transform", "translate(20,20)");

  var max = values.length * 10;
  var maxValue = 60000;

  var y = d3.scale.linear()
     .domain([0, max])
     .range([0, chartHeight]);

  var x = d3.scale.ordinal()
     .domain([0, maxValue])
     .range([0, chartWidth]);

 

  chart.selectAll("rect")
      .data(values)
      .enter()
      .append("rect")
      .attr("class", "bar")
      .attr("y",function(d, i){return (barHeight + barInterval) *i; })
      .attr("x", 100)
      .attr("height", barHeight)
      .attr("width", function(d){return d.value/100; });

  var texts = chart.selectAll("text")
      .data(values)
      .enter()
      
      texts.append("text")
      .attr("y",function(d, i){return (barHeight + barInterval) * i; })
      .attr("dy","20px")
      .attr("x", -20)
      .attr("dx","20px")
      .text(function(d){ return d.label});

      texts.append("text")
      .attr("y",function(d, i){return (barHeight + barInterval) * i; })
      .attr("dy","20px")
      .attr("x", function(d){return d.value/100 - 20 + 120; })
      .attr("dx","5px")
      .text(function(d){ return d.value});
}

function number_of_agreements_by_month(){
  line_chart ("#agreements_by_moth", get_values_for_charts($('#agreements_by_moth li')));
}

function agreements_amount_by_month (argument) {
  line_chart ("#agreements_amount_by_moth", get_values_for_charts($('#agreements_amount_by_moth li')));
}

function line_chart(container, data) {
  var svg_element = container + " svg";
  var info_element = container + " .infobox";
  var margins = [20, 30, 20, 60];
  var width = 600 - margins[1] - margins[3];
  var height = 360 - margins[0] - margins[2];

  var y = d3.scale.linear().domain([0, d3.max(data, function(d) { return parseInt(d.value); } )]).range([height, 0]);
  var x = d3.scale.linear().domain([0, data.length]).range([0, width]);

  function showData(obj, d) {
    var coord = d3.mouse(obj);
    var infobox = d3.select(info_element);
    
    // now we just position the infobox roughly where our mouse is
    infobox.style("left", (coord[0] + 100) + "px" );
    infobox.style("top", (coord[1] - 175) + "px");
    $(info_element).html(d.label + ": " + d.value);
    console.log(infobox)
    console.log(d.label + ": " + d.value);
    $(info_element).show();
  }
   
  function hideData() {
    $(info_element).hide();
  }

  var yAxisLeft = d3.svg.axis().scale(y).ticks(7).orient("left");

  var line = d3.svg.line()
    .x(function(d, i) {return x(d.key);})
    .y(function(d) {return y(d.value);});

  var graph = d3.select(svg_element)
     .attr("height", height + margins[0] + margins[2])
     .attr("width", width + margins[1] + margins[3])
     .append("g")
     .attr("transform", "translate(" + margins[3] + "," + margins[0] + ")");
  graph
    .selectAll("circle")
    .data(data)
    .enter().append("circle")
    .attr("fill", "steelblue")
    .attr("r", 5)
    .attr("cx", function(e) { return x(e.key)})
    .attr("cy", function(e) { return y(e.value)})
    .on("mouseover", function(d) { showData(this, d);})
    .on("mouseout", function(){ hideData();});

  graph.append("path").attr("d", line(data));

  //adding y axis
  graph.append("g")
    .attr("transform", "translate(0,0)")
    .call(yAxisLeft);
}

function number_of_agreements_by_signatories(){
  pie_chart ("#agreements_by_number_of_sinatories svg", get_values_for_charts($('#agreements_by_number_of_sinatories li')));
}

function pie_chart(svg_element, data){
  var width = 600;
  var height = 360;

  var color = d3.scale.ordinal().range(["#d0643c", "#e2a683", "#777778", "#f8eadf", "#b3b2b3", "#f1d4c0", "#c7c6c7", "#eabea2", "#e9e9e8"]);

  var radius = Math.min(width, height) / 2;
  var arc = d3.svg.arc()
    .outerRadius(radius - 5)
    .innerRadius(radius - 100);

  var pie = d3.layout.pie()
    .sort(null)
    .value(function(d) { return d.value; });

  var graph = d3.select(svg_element)
     .attr("height", height)
     .attr("width", width)
     .append("g")
     .attr("transform", "translate(" + width/2 + "," + height/2 + ")");

  var g = graph.selectAll(".arc")
    .data(pie(data))
    .enter().append("g");
  g.append("path")
    .attr("d", arc)
    .style("fill", function(d) {return color(d.data.key-1); });
  g.append("text")
    .attr("transform", function(d) { return "translate(" + arc.centroid(d) + ")"; })
    .style("text-anchor", "middle")
    .style("font-size", "12px")
    .text(function(d) { return d.data.label; });

}

function get_values_for_charts(elements_list){
  var values = [];
  elements_list.each(function(index) {
    var label = $(this).find('.label').text();
    var value = $(this).find('.value').text();
    var key = $(this).find('.key').text();
    values.push({"label" : label ,"key" : key , "value" : value});
  });
  return values;
}