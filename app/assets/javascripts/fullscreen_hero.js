//= require jquery
(function () {
  var $window = $(window);
  var $header = $('#header');
  var $top_header = $('#top-header');

  function fullscreenImage() {
    console.log('window', $window.width(), $window.height());
    console.log('$header', $header.height());
    console.log('$top_header', $top_header.height());

    $('.hero-carousel-fullscreen .item').each(function () {
      var $item = $(this);
      var $image = $item.find('img:first-child');
      var idealHeight = $window.height() - $header.height() - $top_header.height();
      var idealWidth = $window.width();

      console.log('image', $image.prop('naturalWidth'), $image.prop('naturalHeight'));

      $item.width(idealWidth).height(idealHeight);
    });
  };

  fullscreenImage();
})();