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

      console.log('idealDimensions', idealWidth, idealHeight);

      $item.width(idealWidth).height(idealHeight);
      //$image.width(idealWidth).height(idealHeight);

      $image.on('load', function () {
        var aspectRatio = $image.prop('naturalWidth') / $image.prop('naturalHeight');
        var ratio = idealHeight / $image.prop('naturalHeight');
        var newWidth = idealWidth * ratio;
        var newLeft = ((idealWidth - newWidth) / 2) + 'px';

        console.log('aspectRatio', aspectRatio)

        if ($image.prop('naturalWidth') < idealWidth) {
          console.log('must increase width');
        } else {
          console.log('must decrease width');
        }

        if (newWidth < idealWidth) {
          console.log('uh oh...new width is less than ideal width');
        }

        if ($image.prop('naturalHeight') < idealHeight) {
          console.log('must increase height');
        } else {
          console.log('must decrease height');
        }

        var heightDiff = Math.abs(idealHeight - $image.prop('naturalHeight'));
        var widthDiff = Math.abs(idealWidth - $image.prop('naturalWidth'));

        if (heightDiff > widthDiff) {
          console.log('need to increase height more than width', newWidth * aspectRatio);
          //newWidth = newWidth * aspectRatio;
          newLeft = 0;
        } else {
          console.log('need to increase width more than height');
        }

        console.log($image.attr('src'), $image.prop('naturalWidth'), $image.prop('naturalHeight'), ratio, newWidth, newLeft);
        
        $image.width(newWidth).height(idealHeight).css('left', newLeft);
      });
      
    });
  };

  fullscreenImage();
})();