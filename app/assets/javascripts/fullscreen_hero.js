//= require jquery
(function () {
  var $window = $(window);
  var $header = $('#header');
  var $top_header = $('#top-header');

  function fullscreenImage() {
    $('.hero-carousel-fullscreen .item').each(function () {
      var $item = $(this);
      var $image = $item.find('img.fullscreen');
      
      var idealHeight = $window.height() - $header.height() - ($top_header.is(':visible') ? $top_header.height() : 0);
      var idealWidth = $window.width();

      $item.width(idealWidth).height(idealHeight);

      var imageWidth = $image.data('width');
      var imageHeight = $image.data('height');
      var aspectRatio = imageWidth / imageHeight;
      
      var newHeight = idealHeight;
      var newWidth = newHeight * aspectRatio;
      var newLeft = -Math.abs((newWidth - idealWidth) / 2);

      if (newWidth < idealWidth) {
        newWidth = idealWidth;
        newHeight = newWidth * (imageHeight / imageWidth);
        newLeft = 0;
      }

      $image.width(newWidth).height(newHeight).css('left', newLeft);
    });
  };

  fullscreenImage();

  $window.on('resize', fullscreenImage);
})();