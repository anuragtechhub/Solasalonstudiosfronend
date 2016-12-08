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

  // animated scroll
  $('a[href*="#"]:not([href="#"])').click(function() {
    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
      if (target.length) {
        $('html, body').animate({
          scrollTop: target.offset().top
        }, 1000);
        return false;
      }
    }
  });

});