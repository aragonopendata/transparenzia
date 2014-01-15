// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require d3.v3
//= require nv.d3.min
//= require_tree .


var geocoder
$(function() {  
  genre_pie();
  by_place_graph();
  by_department_graph();
  by_tipology_graph();

  line_charts();

  geocoder = new google.maps.Geocoder();
  var map = initialize_map();
  //move_to('La Jacetania, Aragón', map);
});

function by_place_graph(){
  var values = []
  $('#by_place li').each(function(index) {
    var label = $(this).find('.label').text();
    var value = $(this).find('.value').text()
    values.push({"label" : label , "value" : value});
  });
  bar_graphs(values, "#by_place svg");
}
function by_department_graph(){
  var values = []
  $('#by_department li').each(function(index) {
    var label = $(this).find('.label').text();
    var value = $(this).find('.value').text()
    values.push({"label" : label , "value" : value});
  });
  bar_graphs(values, "#by_department svg");
}
function by_tipology_graph(){
  var values = []
  $('#by_tipology li').each(function(index) {
    var label = $(this).find('.label').text();
    var value = $(this).find('.value').text()
    values.push({"label" : label , "value" : value});
  });
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

function line_charts() {
  var svg_element = "#agreements_by_moth svg"
  var data = get_values_for_charts($('#agreements_by_moth li'));

  var margins = [20, 30, 20, 60];
  var width = 600 - margins[1] - margins[3];
  var height = 360 - margins[0] - margins[2];

  var y = d3.scale.linear().domain([0, d3.max(data, function(d) { return d.value; } )]).range([height, 0]);
  var x = d3.scale.linear().domain([0, data.length]).range([0, width]);

  var yAxisLeft = d3.svg.axis().scale(y).ticks(7).orient("left");
  var xAxis = d3.svg.axis().scale(x).tickSize(-height);

  var line = d3.svg.line()
    .x(function(d, i) {return x(d.key-1);})
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
    .attr("cx", function(e) { return x(e.key-1)})
    .attr("cy", function(e) { return y(e.value)});
  graph.append("path").attr("d", line(data));

  //adding x and y axis
  graph.append("g")
    .attr("transform", "translate(-25,0)")
    .call(yAxisLeft);
  graph.append("g")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis);
}

function genre_pie(){
  var genre_percentage = [
    {key: "Hombres", y: $('#number_of_men').text()},
    {key: "Mujeres", y: $('#number_of_women').text()}
  ];
  nv.addGraph(function() {
    var width = 200, height = 200;
    var chart = nv.models.pieChart()
      .x(function(d) { return d.key })
      .y(function(d) { return d.y })
      .color(d3.scale.category10().range())
      .width(width)
      .height(height);
    d3.select("#genre_percentage")
      .datum(genre_percentage)
      .transition().duration(3000)
      .attr('width', width)
      .attr('height', height)
      .call(chart);

    chart.dispatch.on('stateChange', function(e) { nv.log('New State:', JSON.stringify(e)); });
    return chart;
  });
}

function get_values_for_charts(elements_list){
  var values = [];
  elements_list.each(function(index) {
    var label = $(this).find('.label').text();
    var value = $(this).find('.value').text()
    values.push({"label" : label ,"key" : label , "value" : value});
  });
  return values;
}

function initialize_map() {
    var mapOptions = {
      center: new google.maps.LatLng(41.5976275, -0.9056623),
      zoom: 7,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    return new google.maps.Map(document.getElementById("map"), mapOptions);
}

function move_to(place, map){
	geocoder.geocode( { 'address': place}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      map.setCenter(results[0].geometry.location);
      map.setZoom(9)
    } else {
      alert('Geocode was not successful for the following reason: ' + status);
    }
  });
}