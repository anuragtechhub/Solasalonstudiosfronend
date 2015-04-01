$(function () {

  var mapStyles = [
    {
        "featureType": "administrative",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "saturation": -100
            },
            {
                "lightness": 20
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "saturation": -100
            },
            {
                "lightness": 40
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "color": "#C1E6F3"
            }
        ]
    },
    {
      featureType: "water",
      elementType: "labels",
      stylers: [
        { visibility: "off" }
      ]
    },
    {
        "featureType": "landscape.man_made",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "simplified"
            },
            {
                "saturation": -60
            },
            {
                "lightness": 10
            }
        ]
    },
    {
        "featureType": "landscape.natural",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "simplified"
            },
            {
                "saturation": -60
            },
            {
                "lightness": 60
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            },
            {
                "saturation": -100
            },
            {
                "lightness": 60
            }
        ]
    },
    {
        "featureType": "transit",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            },
            {
                "saturation": -100
            },
            {
                "lightness": 60
            }
        ]
    }
  ];

  // map
  
  var map = new GMaps({
    div: '#map',
    lat: parseFloat($('#lat').val(), 10),
    lng: parseFloat($('#lng').val(), 10),
    zoom: parseInt($('#zoom').val(), 10),
    styles: mapStyles
  });

  // markers
  
  var openWindow = null;

  $('input[name=marker]').each(function () {
    var $this = $(this),
        coords = $this.val().split(', '),
        name = $this.data('name'),
        address = $this.data('address'),
        url = $this.data('url');
    
    setTimeout(function () {
      var marker = map.addMarker({
        lat: coords[0],
        lng: coords[1],
        title: name,
        click: function(e) {
          var ib = new InfoBox({
            content: '<div class="sola-infobox"><h3>' + name + '</h3><p>' + address + '</p><a href="' + url + '">View Location</a></div>',
            closeBoxURL: '',
            pixelOffset: new google.maps.Size(-50, -100)
          });
          if (openWindow && typeof openWindow.close === 'function') {
            openWindow.close();
          }
          ib.open(map.map, marker);
          openWindow = ib;
        }
      });
    }, 0);
  });

});