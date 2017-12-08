$(function () {
	
  /**
  * Own Your Salon subnav
  */
  var showOysNav = function () {
    if ($(window).width() > 1000) {
      // desktop
      var $headerContainer = $('#header .container');
      $('.oys-nav').css({left: $headerContainer.offset().left, top: $headerContainer.outerHeight() + $('#top-header').outerHeight() - 1}).width($headerContainer.outerWidth()).show();
    }
  };

  $('.oys-nav-caret').on('click', function () {
    var $this = $(this);

    if ($this.hasClass('down')) {
      $this.removeClass('down').addClass('up');
      $('.oys-nav-mobile').slideDown('fast');
    } else {
      $this.removeClass('up').addClass('down');
      $('.oys-nav-mobile').slideUp('fast');
    }
  });

  $('#header .own_your_salon').on('mouseenter', function () {
    //showOysNav();
  }).hoverIntent({
    over: function () {
      showOysNav();
    }, 
    out: function () {
      var $oysNav = $('.oys-nav');

      if ($oysNav.hasClass('over')) {
        // shhh...
      } else {
        $oysNav.hide();
      }
    },
    timeout: 500
  });

  $('.oys-nav').on('mouseenter', function () {
    $('.oys-nav').addClass('over').show();
  });  

  $('.oys-nav').on('mouseleave', function () {
    $('.oys-nav').removeClass('over').hide();
  }); 



  /**
  * Window resize handler
  */
  $(window).on('resize.oysNav', function () {
    if ($(window).width() > 1000) {
      // desktop
      $('.oys-nav-mobile').hide();
      $('#header .nav .caret').removeClass('up').addClass('down');
    }
  }).trigger('resize.oysNav');

});