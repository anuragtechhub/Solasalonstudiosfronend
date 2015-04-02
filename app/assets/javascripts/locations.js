$(function () {

  var mapStyles = [{featureType:"administrative",elementType:"all",stylers:[{visibility:"on"},{saturation:-100},{lightness:20}]},{featureType:"road",elementType:"all",stylers:[{visibility:"on"},{saturation:-100},{lightness:40}]},{featureType:"water",elementType:"all",stylers:[{visibility:"on"},{color:"#C1E6F3"}]},{featureType:"water",elementType:"labels",stylers:[{visibility:"off"}]},{featureType:"landscape.man_made",elementType:"all",stylers:[{visibility:"simplified"},{saturation:-60},{lightness:10}]},{featureType:"landscape.natural",elementType:"all",stylers:[{visibility:"simplified"},{saturation:-60},{lightness:60}]},{featureType:"poi",elementType:"all",stylers:[{visibility:"off"},{saturation:-100},{lightness:60}]},{featureType:"transit",elementType:"all",stylers:[{visibility:"off"},{saturation:-100},{lightness:60}]}];

  // map
  
  var map = new GMaps({
    div: '#map',
    lat: parseFloat($('#lat').val(), 10),
    lng: parseFloat($('#lng').val(), 10),
    zoom: parseInt($('#zoom').val(), 10),
    streetViewControl: false,
    mapTypeControlOptions: {
      mapTypeIds: []
    },
    styles: mapStyles
  });

  // markers
  
  var openWindow = null;

  var getMarkerContent = function (name, saddress, address, url, salon) {
    if (salon) {
        return '<div class="sola-infobox"><h3>' + name + '</h3><p>' + address + '</p><a target="_blank" href="http://maps.google.com/maps?daddr=' + saddress + '">Map it!</a><div class="tail1"></div><div class="tail2"></div></div>'
    } else {
        return '<div class="sola-infobox"><h3>' + name + '</h3><p>' + address + '</p><a href="' + url + '">View Location</a><div class="tail1"></div><div class="tail2"></div></div>';
    }
  };

  $('input[name=marker]').each(function () {
    var $this = $(this),
        coords = $this.val().split(', '),
        name = $this.data('name'),
        saddress = $this.data('saddress'),
        address = $this.data('address'),
        url = $this.data('url'),
        salon = $this.data('salon');
    
    setTimeout(function () {
      var markerIcon = new google.maps.MarkerImage($('#marker-icon-url').val(), null, null, null, new google.maps.Size(19,19)),
        marker = map.addMarker({
        lat: coords[0],
        lng: coords[1],
        icon: markerIcon,
        title: name,
        click: function(e) {
          var ib = new InfoBox({
            content: getMarkerContent(name, saddress, address, url, salon),
            closeBoxURL: '',
            pixelOffset: new google.maps.Size(-100, -200)
          });
          if (openWindow && typeof openWindow.close === 'function') {
            openWindow.close();
          }
          ib.open(map.map, marker);
          openWindow = ib;

          map.map.panTo(marker.getPosition());
          
          //position infobox
          setTimeout(function () {
            var $div = $('.infoBox');
            
            $div.show();
            
            setTimeout(function () {
                $div.show().css({'left': '-=' + (($div.width() / 2) - 100), 'top': '-=' + (($div.height() + 31) - 200)}).css('opacity', 1);

                setupMapChangeEventListeners();
            }, 100);
          }, 100);

          function setupMapChangeEventListeners () {
            google.maps.event.addListenerOnce(map.map, 'drag', function () {   
              if (openWindow && typeof openWindow.close === 'function') {
                openWindow.close();
              }
            }); 

            google.maps.event.addListenerOnce(map.map, 'bounds_changed', function () {   
              if (openWindow && typeof openWindow.close === 'function') {
                openWindow.close();
              }
            });  

            google.maps.event.addListenerOnce(map.map, 'zoom_changed', function () {   
              if (openWindow && typeof openWindow.close === 'function') {
                openWindow.close();
              }
            }); 
          }
        }
      });

      google.maps.event.addListenerOnce(map.map, 'idle', function() {
        if (salon) {
          setTimeout(function () {
              new google.maps.event.trigger(marker, 'click'); 
          }, 100);
        }
      });    
    }, 0);
  });

 var $map = $('#map');
 if ($map.hasClass('fullscreen')) {
    $map.css('height', $(window).height());
 }

 $('#map-overlay').css('top', $map.offset().top).show().on('click', function () { $('#map-overlay').remove(); });

});