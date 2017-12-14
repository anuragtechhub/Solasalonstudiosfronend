$(function () {
	
  /**
  * 'oys' (Own Your Salon and About Us) subnav menus
  */
  var showOysNav = function (nav) {
    if ($(window).width() > 1000) {
      // desktop
      var $headerContainer = $('#header .container');
      $('.oys-nav[data-nav="' + nav + '"]').css({left: $headerContainer.offset().left, top: $headerContainer.outerHeight() + $('#top-header').outerHeight() - 1}).width($headerContainer.outerWidth()).show();
    }
  };

  $('#header .own_your_salon, #header .about_us').on('mouseenter', function () {
    //showOysNav();
  }).hoverIntent({
    over: function (e) {
      var $this = $(e.target);
      showOysNav($this.data('nav'));
    }, 
    out: function (e) {
      var $this = $(e.target);

      var $oysNav = $('.oys-nav[data-nav="' + $this.data('nav') + '"]');

      if ($oysNav.hasClass('over')) {
        // shhh...
      } else {
        $oysNav.hide();
      }
    },
    timeout: 500
  });

  $('.oys-nav').on('mouseenter', function (e) {
    var $this = $(e.target);
    $('.oys-nav[data-nav="' + $this.data('nav') + '"]').addClass('over').show();
  });  

  $('.oys-nav').on('mouseleave', function (e) {
    var $this = $(e.target);
    $('.oys-nav[data-nav="' + $this.data('nav') + '"]').removeClass('over').hide();
  }); 

});