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
	geocoder = new google.maps.Geocoder();
	var map = initialize_map();
	//move_to('La Jacetania, Aragón', map);

  var genre_percentage = [
    {
      key: "Hombres",
      y: $('#number_of_men').text()
    },
    {
      key: "Mujeres",
      y: $('#number_of_women').text()
    }
  ];


nv.addGraph(function() {
    var width = 200,
        height = 200;

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

});  

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
