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

  vertical_graphs();

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

function vertical_graphs() {
  var svg_element = "#agreements_by_moth svg"
  var values = []
  $('#agreements_by_moth li').each(function(index) {
    var label = $(this).find('.label').text();
    var value = $(this).find('.value').text()
    values.push({"label" : label , "value" : value});
  });

  var barWidth = 5;
  var barInterval = 30;
  var chartHeight = 300;
  var chartWidth = "30%";

  var chart = d3.select(svg_element)
     .attr("height", chartHeight+20)
     .attr("width", chartWidth)
     .append("g")
     .attr("transform", "translate(20,20)");

  var max = values.length * 10;
  var maxValue = 60000;
  var maxHeight 

  chart.selectAll("rect")
      .data(values)
      .enter()
      .append("rect")
      .attr("y", function(d){return chartHeight-d.value-50; })
      .attr("x", function(d, i){return (barInterval) *i; })
      .attr("height", function(d){return d.value; })
      .attr("width", barWidth);

  var texts = chart.selectAll("text").data(values).enter();
      
      texts.append("text")
      .attr("y", chartHeight - 30)
      .attr("dy","10px")
      .attr("x", function(d, i){return (barInterval) * i; })
      .attr("dx","0px")
      .text(function(d){ return d.label});

      texts.append("text")
      .attr("y", function(d){return chartHeight-d.value-100; })
      .attr("dy","20px")
      .attr("x", function(d, i){return (barInterval) * i; })
      .attr("dx","0px")
      .text(function(d){ return d.value});
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