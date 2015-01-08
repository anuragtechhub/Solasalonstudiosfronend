$(function () {

  function randomIndex (max) {
    return Math.floor(Math.random() * max);
  };

  function randomInterval (min, max) {
    return Math.floor(Math.random() * ( max - min + 1) + min);
  };

  function imageVisible (image) {
    return $('.photo[data-image=' + image.attr('src') + ']').length > 0;
  };

  function swapImage (photo) {
    var img = randomIndex(images.length);

    photo.attr('data-image', img.attr('src'));
  };
  
  var images = $('.images img'),
      photos = $('.photo'),
      min = 2, max = 8;

  // photo 1

  // photo 2

  // photo 3

  photos.eq(1).on('click', function () {
    alert('2')
  })

  photos.eq(2).on('click', function () {
    alert('3')
  }) 

  console.log(images.length, randomIndex(images.length))

});