$(function () {

  // map
  var map = new GMaps({
    div: '#map',
    lat: parseFloat($('#lat').val(), 10),
    lng: parseFloat($('#lng').val(), 10),
    zoom: parseInt($('#zoom').val(), 10)
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