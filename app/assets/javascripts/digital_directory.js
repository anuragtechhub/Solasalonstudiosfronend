//= require jquery

$(function () {

  /**
  * Auto refreshes the page
  * @param {Integer} hours (default is 1)
  */
  startRefreshTimeout = function (hours) {
    var hours = hours || 1;
    setTimeout(function () {
      if (navigator && navigator.onLine) {
        window.location.reload(true);
      } else {
        startRefreshTimeout(0.25);
      }
    }, 1000 * 60 * 60 * hours);
  };

  /* 
  * Gets an random integer index value given an integer array length 
  * @param {Integer} length
  * @returns {Integer} index
  */
  function randomIndex (length) {
    return Math.floor(Math.random() * length);
  };

  /* 
  * Gets an random integer value between two min and max integers
  * @param {Integer} min
  * @param {Integer} max
  * @returns {Integer} value
  */
  function randomInterval (min, max) {
    return Math.floor(Math.random() * ( max - min + 1) + min);
  };

  function swapImage () {
    var $slot, $image;

    //select random photo slot
    do {
      $slot = $photos.eq(randomIndex($photos.length));
    } while ($slot.is($last_slot));
    $last_slot = $slot;
    

    //select random image
    do {
      $image = $images.eq(randomIndex($images.length));
    } while ($image.is(':visible'));

    $image.hide();
    $slot.append($image).find('img').not($image).fadeOut('slow');
    $image.fadeIn('slow');

    setTimeout(swapImage, randomInterval(min_interval, max_interval) * 1000);
  }


  var $images = $('#photo-gallery-images img'),
      $photos = $('#photo-gallery .photo'),
      min_interval = 4, max_interval = 6, $last_slot;

  //init    
  $photos.eq(0).append($images.eq(0));
  $photos.eq(1).append($images.eq(1));
  $photos.eq(2).append($images.eq(2));

  swapImage();
  //startRefreshTimeout();

});