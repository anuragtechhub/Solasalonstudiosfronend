$(function () {

  var scrollTop = 0;

  $('#showBios').on('click', function () {
    scrollTop = $(document.body).scrollTop();
    $('.bios').slideDown(function () {
      $('#showBios').hide();
      $('#hideBios').show();
    });
  });

  $('#hideBios').on('click', function () {
    $('.bios').slideUp(function () {
      $('#hideBios').hide();
      $('#showBios').show();
    });
    $(document.body).animate({scrollTop: scrollTop});
  });

  // testimonial sizing
  var resizeId;
  $(window).on('resize.testimonial', function() {
    clearTimeout(resizeId);
    resizeId = setTimeout(doneResizing, 500);
  }).trigger('resize');
   
  function doneResizing() {
    var largest = 0;

    $('.testimonials .owl-item').css('height','auto').each(function () {
      var height = this.scrollHeight * 2;
      
      if (height > largest) {
        largest = height;
      }
    });
    
    $('.testimonials .owl-item').height(largest);
  };

  // galleries

  $('#view-denver-gallery').click(function () {
    var images = [];

    $('#denver-gallery').find('span').each(function () {
      images.push({href: $(this).data('src')});
    });

    $.swipebox(images);

    return false;
  });

  $('#view-minneapolis-gallery').click(function () {
    var images = [];

    $('#minneapolis-gallery').find('span').each(function () {
      images.push({href: $(this).data('src')});
    });

    $.swipebox(images);

    return false;
  });

});