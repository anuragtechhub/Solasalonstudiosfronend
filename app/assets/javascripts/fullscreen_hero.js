//= require jquery
(function () {
  var $window = $(window);
  var $header = $('#header');
  var $top_header = $('#top-header');

  function fullscreenImage() {
    // console.log('window', $window.width(), $window.height());
    // console.log('$header', $header.height());
    // console.log('$top_header', $top_header.height());

    $('.hero-carousel-fullscreen .item').each(function () {
      var $item = $(this);
      var $image = $item.find('img.fullscreen');
      
      var idealHeight = $window.height() - $header.height() - $top_header.height();
      var idealWidth = $window.width();

      //console.log('idealDimensions', idealWidth, idealHeight);

      $item.width(idealWidth).height(idealHeight);
      //$image.width(idealWidth).height(idealHeight);

      //$image.on('load', function () {
        var imageWidth = $image.data('width');
        var imageHeight = $image.data('height');
        var aspectRatio = imageWidth / imageHeight;

        var ratio = idealHeight / imageHeight;
        
        var newWidth = idealWidth * ratio;
        var newLeft = ((idealWidth - newWidth) / 2) + 'px';

        console.log($image.attr('src'), 'aspectRatio', aspectRatio, 'ratio', ratio);

        if ($image.prop('naturalWidth') < idealWidth) {
          console.log('must increase width');
        } else {
          console.log('must decrease width');
        }

        if ($image.prop('naturalHeight') < idealHeight) {
          console.log('must increase height');
        } else {
          console.log('must decrease height');
        }

        var heightDiff = Math.abs(idealHeight - imageHeight);
        var widthDiff = Math.abs(idealWidth - imageWidth);

        if (heightDiff > widthDiff) {
          console.log('need to increase height more than width', newWidth * aspectRatio);
          //newWidth = newWidth * aspectRatio;
          //newLeft = 0;
        } else {
          console.log('need to increase width more than height');
        }

        console.log(imageHeight, imageWidth, newWidth, newLeft);
        
        $image.width(newWidth).height(idealHeight).css('left', newLeft);
      //});
      
    });
  };

  fullscreenImage();
})();