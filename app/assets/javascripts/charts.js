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
  line_chart ("#agreements_by_month", get_values_for_charts($('#agreements_by_month li')));
}

function number_of_agreements_by_month(){
  line_chart ("#agreements_by_month", get_values_for_charts($('#agreements_by_month li')));
}





function line_chart(container, data) {
  var svg_element = container + " svg";
  var info_element = container + " .infobox";
  
  var margins = [70, 25, 55, 75];
  
  var width = $(container).width() - margins[1] - margins[3];
  var height = $(container).height() - margins[0] - margins[2];
  
  var intervalos_x = data.length;
  var intervalos_y = 10;
  
  var maximo = d3.max(data, function(d) { return parseInt(d.value); } ) * 1.1;
  if(maximo < 100000 && maximo > 80000) maximo = 100000;
  if(maximo < 1000000 && maximo > 800000) maximo = 1000000;
  
  var y = d3.scale.linear().domain([0, maximo]).range([height, 0]);
  var x = d3.scale.linear().domain([0, intervalos_x]).range([0, width]);



  function showData(obj, d) {
    var coord = d3.mouse(obj);
    var infobox = d3.select(info_element);
    
    // now we just position the infobox roughly where our mouse is
    infobox.style("left", (coord[0]) + "px" );
    infobox.style("top", (coord[1] - 75) + "px");
    $(info_element).html(d.label);
    $(info_element).show();
  }
   
   
   
   
   
  function hideData() {
    $(info_element).hide();
  }
  var etiquetas = [];
  for( var i in data ) {
    etiquetas[i] = data[i].label;
  }

  var xAxis = d3.svg.axis().scale(x).tickFormat(function (d) { return etiquetas[d] });

  var line = d3.svg.line()
    .x(function(d, i) {return x(d.key)+(width/(intervalos_x*2));})
    .y(function(d) {return y(d.value);});

  var graph = d3.select(svg_element)
     .attr("height", height + margins[0] + margins[2])
     .attr("width", width + margins[1] + margins[3])
     .append("g")
     .attr("transform", "translate(" + margins[3] + "," + margins[0] + ")");
     

  var title = $(container).find(".chart-title").text();
  d3.select(svg_element).append("text")
    .attr("transform", "translate(25,40)")
    .attr("class", "graph_title")
    .attr("fill", "#535353")
    .text(title);
  
  //units
  var units_y = $(container).find(".units-y").text();
  d3.select(svg_element).append("text")
    //.attr("width", 50)
    .attr("transform", "translate(65,65)")
    .attr("text-anchor", "end")
    .text(units_y);
  
  graph.selectAll(".xTicks")
  .data(x.ticks(intervalos_x))
  .enter().append("svg:line")
  .attr("class", "xTicks")
  .attr("x1", function(d) { return x(d); })
  .attr("y1", height)
  .attr("x2", function(d) { return x(d); })
  .attr("y2", height+5)

  graph.selectAll(".yTicks")
  .data(y.ticks(intervalos_y))
  .enter().append("svg:line")
  .attr("class", "yTicks")
  .attr("y1", function(d) { return -1 * y(d) + height; })
  .attr("x1", -5)
  .attr("y2", function(d) { return -1 * y(d) + height; })
  .attr("x2", width)

  graph.selectAll(".yLabel")
  .data(y.ticks(intervalos_y))
  .enter().append("svg:text")
  .attr("class", "yLabel")
  .text(String)
  .attr("x", -10)
  .attr("y", function(d) { return 1 * y(d) })
  .attr("text-anchor", "end")
  
  
  graph.append("svg:line")
  .attr("x1", 0)
  .attr("y1", -1)
  .attr("x2", 0)
  .attr("y2", height)
  
  graph.append("svg:line")
  .attr("x1", 0)
  .attr("y1", height)
  .attr("x2", width+1)
  .attr("y2", height)
  
  
  graph.append("path").attr("d", line(data));

  graph.append("g")
  .attr("transform", "translate(" + width/(intervalos_x*2) + "," + (height+7) + ")")
  .attr("class", "y axis")
  .call(xAxis);

  graph.selectAll('.axis line, .axis path').style({'stroke-width':'0'});
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