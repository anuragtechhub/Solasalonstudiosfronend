$(function () {

  var mapStyles = [{featureType:"administrative",elementType:"all",stylers:[{visibility:"on"},{saturation:-100},{lightness:20}]},{featureType:"road",elementType:"all",stylers:[{visibility:"on"},{saturation:-100},{lightness:40}]},{featureType:"water",elementType:"all",stylers:[{visibility:"on"},{color:"#C1E6F3"}]},{featureType:"water",elementType:"labels",stylers:[{visibility:"off"}]},{featureType:"landscape.man_made",elementType:"all",stylers:[{visibility:"simplified"},{saturation:-60},{lightness:10}]},{featureType:"landscape.natural",elementType:"all",stylers:[{visibility:"simplified"},{saturation:-60},{lightness:60}]},
  {featureType:"poi",elementType:"all",stylers:[{visibility:"off"},{saturation:-100},{lightness:60}]},{featureType:"transit",elementType:"all",stylers:[{visibility:"off"},{saturation:-100},{lightness:60}]}];

  // map
  
  var map = new GMaps({
    div: '#map',
    lat: 56.1304,
    lng: -99.3468,
    zoom: 4,
    streetViewControl: false,
    draggable: $('#is_salon').length > 0 ? false : true,
    scrollwheel: false,//$('#is_salon').length > 0 ? false : true,
    disableDefaultUI: $('#is_salon').length > 0 ? true : false,
    mapTypeControlOptions: {
      mapTypeIds: []
    },
    styles: mapStyles
  });  

});