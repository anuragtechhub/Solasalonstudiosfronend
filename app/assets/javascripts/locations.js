$(function () {

  var mapStyles = [{featureType:"administrative",elementType:"all",stylers:[{visibility:"on"},{saturation:-100},{lightness:20}]},{featureType:"road",elementType:"all",stylers:[{visibility:"on"},{saturation:-100},{lightness:40}]},{featureType:"water",elementType:"all",stylers:[{visibility:"on"},{color:"#C1E6F3"}]},{featureType:"water",elementType:"labels",stylers:[{visibility:"off"}]},{featureType:"landscape.man_made",elementType:"all",stylers:[{visibility:"simplified"},{saturation:-60},{lightness:10}]},{featureType:"landscape.natural",elementType:"all",stylers:[{visibility:"simplified"},{saturation:-60},{lightness:60}]},
  {featureType:"poi",elementType:"all",stylers:[{visibility:"off"},{saturation:-100},{lightness:60}]},{featureType:"transit",elementType:"all",stylers:[{visibility:"off"},{saturation:-100},{lightness:60}]}];

  // map
  
  var map = new GMaps({
    div: '#map',
    lat: parseFloat($('#lat').val(), 10),
    lng: parseFloat($('#lng').val(), 10),
    zoom: parseInt($('#zoom').val(), 10),
    streetViewControl: false,
    draggable: $('#is_salon').length > 0 ? false : true,
    scrollwheel: false,//$('#is_salon').length > 0 ? false : true,
    disableDefaultUI: $('#is_salon').length > 0 ? true : false,
    mapTypeControlOptions: {
      mapTypeIds: []
    },
    styles: mapStyles
  });  

  function loadAllLocationMarkers() {
    process_markers($('input[name=all_markers]'));
  };

  // markers
  
  var openWindow = null;
  var latlngbounds = new google.maps.LatLngBounds();
  var $markers = $('input[name=marker]');
  var closeMarker = false;
  var ib;
  var zoomCount = 0;

  var getMarkerContent = function (name, saddress, address, url, salon, custom_maps_url) {
    if (salon) {
      if (custom_maps_url) {
        return '<div class="sola-infobox"><h3>' + name + '</h3><p>' + address + '</p><a target="_blank" href="' + custom_maps_url + '">Map it!</a><div class="tail1"></div><div class="tail2"></div></div>'
      } else {
        return '<div class="sola-infobox"><h3>' + name + '</h3><p>' + address + '</p><a target="_blank" href="http://maps.google.com/maps?daddr=' + saddress + '">Map it!</a><div class="tail1"></div><div class="tail2"></div></div>'
      }
    } else {
        return '<div class="sola-infobox"><h3>' + name + '</h3><p>' + address + '</p><a href="' + url + '">View Location</a><div class="tail1"></div><div class="tail2"></div></div>';
    }
  };

  function process_markers($markers) {
    $markers.each(function () {
      var $this = $(this),
          coords = $this.val().split(', '),
          name = $this.data('name'),
          saddress = $this.data('saddress'),
          address = $this.data('address'),
          url = $this.data('url'),
          custom_maps_url = $this.data('custom-maps-url'),
          salon = $this.data('salon'),
          marker, markerIcon;
      
    latlngbounds.extend(new google.maps.LatLng(coords[0], coords[1]));

    function isInfoWindowOpen () {
      if (ib && $(ib.div_).length > 0 && $(ib.div_).is(':visible')) {
        return true;
      } else {
        return false;
      }
    }

    function openInfoBox() {
      ib = new InfoBox({
        content: getMarkerContent(name, saddress, address, url, salon, custom_maps_url),
        closeBoxURL: '',
        pixelOffset: new google.maps.Size(-100, -200)
      });
      window.ib = ib;
      
      if (openWindow && typeof openWindow.close === 'function') {
        openWindow.close();
      }
      
      ib.open(map.map, marker);
      openWindow = ib;

      closeMarker = false;
      map.map.panTo(marker.getPosition());



      //position infobox
      setTimeout(function () {
        var $div = $('.infoBox');

        $div.show();

        setTimeout(function () {
          $div.show().css({'left': '-=' + (($div.width() / 2) - 100), 'top': '-=' + (($div.height() + 31) - 200)}).css('opacity', 1);
          closeMarker = true;

          if (!isInfoWindowOpen()) {
            setTimeout(openInfoBox, 100);
          }
        }, 100);
      }, 100);     
    }


      setTimeout(function () {
        markerIcon = new google.maps.MarkerImage($('#marker-icon-url').val(), null, null, null, new google.maps.Size(19,19));
        marker = map.addMarker({
          lat: coords[0],
          lng: coords[1],
          icon: markerIcon,
          title: name,
          click: function(e) {
            openInfoBox();
          }
        });

        function setupMapChangeEventListeners () {
          google.maps.event.addListener(map.map, 'drag', function () {  
            if (closeMarker && openWindow && typeof openWindow.close === 'function') {
              openWindow.close();
            }
          }); 

          google.maps.event.addListener(map.map, 'bounds_changed', function () {   
            if (closeMarker && openWindow && typeof openWindow.close === 'function') {
              openWindow.close();
            }
          });  

          google.maps.event.addListener(map.map, 'zoom_changed', function () { 
            zoomCount = zoomCount + 1;

            if (zoomCount == $markers.length + 1) {
              loadAllLocationMarkers();
            }
            if (closeMarker && openWindow && typeof openWindow.close === 'function') {
              openWindow.close();
            }
          }); 
        };
        
        setupMapChangeEventListeners();
        
        google.maps.event.addListenerOnce(map.map, 'idle', function() {
          if (zoomCount == 0) {
            if (salon) {
              setTimeout(function () {
                openInfoBox();
              }, 100);
            } else {
              // autocenter and zoom
              function getZoomByBounds( map, bounds ){
                var MAX_ZOOM = map.mapTypes.get( map.getMapTypeId() ).maxZoom || 21 ;
                var MIN_ZOOM = map.mapTypes.get( map.getMapTypeId() ).minZoom || 0 ;

                var ne= map.getProjection().fromLatLngToPoint( bounds.getNorthEast() );
                var sw= map.getProjection().fromLatLngToPoint( bounds.getSouthWest() ); 

                var worldCoordWidth = Math.abs(ne.x-sw.x);
                var worldCoordHeight = Math.abs(ne.y-sw.y);

                //Fit padding in pixels 
                var FIT_PAD = 40;

                for( var zoom = MAX_ZOOM; zoom >= MIN_ZOOM; --zoom ){ 
                    if( worldCoordWidth*(1<<zoom)+2*FIT_PAD < $(map.getDiv()).width() && 
                        worldCoordHeight*(1<<zoom)+2*FIT_PAD < $(map.getDiv()).height() )
                        return zoom;
                }
                return 0;
              }
              
              map.map.setCenter(latlngbounds.getCenter());

              if ($markers.length == 1) {
                map.map.setZoom(15);
              } else {
                map.map.setZoom(getZoomByBounds(map.map, latlngbounds));
              }  
            }
          }
        });    
      }, 0);
    });

  } //end process_markers

  process_markers($markers);

  // map height and overlay
  var $map = $('#map');

  if ($map.hasClass('fullscreen')) {
    $map.css('height', $(window).height());
  }

  //$('#map-overlay').css('top', $map.offset().top).show().on('click', function () { $('#map-overlay').remove(); });

  // scroll to request tour anchor
  $('.rent-a-studio').on('click', function () {
   $('html, body').animate({scrollTop: $('#rent-a-studio').offset().top}, 'slow');
  });

});