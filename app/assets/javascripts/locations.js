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
                "color": "#48bfec"
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
  $('input[name=marker]').each(function () {
    var $this = $(this),
        coords = $this.val().split(', '),
        name = $this.data('name');
    setTimeout(function () {
      map.addMarker({
        lat: coords[0],
        lng: coords[1],
        title: name,
        click: function(e) {
          alert('You clicked ' + name);
        }
      });
    }, 1);
  });

});