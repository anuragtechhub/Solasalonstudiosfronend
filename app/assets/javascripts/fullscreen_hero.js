//= require jquery
(function () {
  var $window = $(window);
  var $header = $('#header');
  var $top_header = $('#top-header');
  var $studio_amenities_image = $('#studio_amenities_img');
  var $amenity_description = $('#amenity-description');

  function studioAmenitiesCheck(idealHeight) {
    // var newBottom = $studio_amenities_image.height() - idealHeight + 10;
    // // check Studio Amenities to see if its taller than the fold
    // if ($studio_amenities_image.is(':visible') && $studio_amenities_image.height() > idealHeight && (newBottom + $amenity_description.height()) < $('#explore-studio').height()) {
    //   $amenity_description.css('bottom', newBottom);
    // } else {
    //   $amenity_description.removeAttr('style');
    // }
  }

  function fullscreenImage() {
    var idealHeight = $window.height() - $header.height() - ($top_header.is(':visible') ? $top_header.height() : 0);
    var idealWidth = $window.width();

    $('.hero-carousel-fullscreen .item').each(function () {
      var $item = $(this);
      var $image = $item.find('img.fullscreen');
      
      $item.width(idealWidth).height(idealHeight);

      var imageWidth = $image.data('width');
      var imageHeight = $image.data('height');
      var aspectRatio = imageWidth / imageHeight;
      
      var newHeight = idealHeight;
      var newWidth = newHeight * aspectRatio;
      var newTop = 0;
      var newLeft = -Math.abs((newWidth - idealWidth) / 2);

      if (newWidth < idealWidth) {
        newWidth = idealWidth;
        newHeight = newWidth * (imageHeight / imageWidth);
        newLeft = 0;
      }

      if (newHeight > idealHeight) {
        newTop = -Math.abs((newHeight - idealHeight) / 2);
      }

      $image.width(newWidth).height(newHeight).css({'left': newLeft, 'top': newTop});
    });

    setTimeout(function () { studioAmenitiesCheck(idealHeight); }, 500);
  };

  fullscreenImage();

  $window.on('resize', fullscreenImage);

  $('.hero-tab-content[data-hero-active]').addClass('hero-active');
})();