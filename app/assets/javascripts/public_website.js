//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require classie
//= require search
//= require gmaps

$(function () {

  var uiSearch = new UISearch( document.getElementById('sb-search'));

  new GMaps({
  div: '#map',
  lat: 39.7392,
  lng: -104.9903,
  zoom: 12
});

});