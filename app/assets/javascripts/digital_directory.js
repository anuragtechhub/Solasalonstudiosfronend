//= require jquery

$(function () {

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

  function swapImage (photo) {
    var image;

    do {
      image = images.eq(randomIndex(images.length));
    } while (photos.filter('[data-image="' + image.attr('src') + '"]').length > 0);

    image = image.clone().hide();
    photo.append(image).attr('data-image', image.attr('src'));
    photo.find('img').fadeOut('slow'); image.fadeIn('slow');

    if (images.length > 3) {
      //refresh after random interval
      setTimeout(function () {
        swapImage(photo);
      }, randomInterval(min_interval, max_interval) * 1000);
    }
  };
  
  var images = $('#photo-gallery-images img'),
      photos = $('#photo-gallery .photo'),
      min_interval = 6, max_interval = 12;

  //init images
  swapImage(photos.eq(0));
  swapImage(photos.eq(1));
  swapImage(photos.eq(2));

});