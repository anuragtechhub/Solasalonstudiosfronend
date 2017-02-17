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

  // hero height
  function calculateHeroHeight() {
    var windowWidth = $(window).width();

    //console.log('windowWidth', windowWidth);

    if (windowWidth <= 900) {
      var outerHeight = 120;
    } else if (windowWidth > 900 && windowWidth <= 1200) {
      var outerHeight = 160;
    //} else if (windowWidth > 1200 && windowWidth <= 1600) {
    //  var outerHeight = 180;
    } else {
      var outerHeight = 160;
    }

    $('.calc-height').each(function () {
      outerHeight += $(this).outerHeight(true);
    })
    //console.log('outerHeight', outerHeight);
    $('.header').height(outerHeight);
  }
  calculateHeroHeight();

  $(window).on('resize.heroHeight', calculateHeroHeight);

  // featured presenter modals
  function initModals() {
    $('.bio').modal();
  }
  initModals();

  $(document).on('click', '.speakers .columns', function () {
    var id = $(this).data('rel');
    $('.bio[data-rel=' + id + ']').data('modal').open();
    return false;
  });

  $(document).on('click', '.modal-header .company a', function () {
    return false;
  });

  // custom scroll
  $('.modal .content').mCustomScrollbar({
    theme: "minimal-light"
  });

  // add to calendar
  var calendar = createCalendar({
    data: {
      title: 'Sola Session Washington D.C.',
      start: new Date('May 8, 2017 09:00'),
      end: new Date('May 8, 2017 18:30'),  
      address: 'Tysons Corner Marriott, 8028 Leesburg Pike, Tysons, VA 22182', 
      description: "On Monday, May 8th, we're bringing the industry's best exclusively to the Sola community for a full day of inspiration and education to help take your salon business to a higher level. We can't wait to see you in DC!"
    }
  });

  $('#add-to-calendar-wrapper').append(calendar);

});