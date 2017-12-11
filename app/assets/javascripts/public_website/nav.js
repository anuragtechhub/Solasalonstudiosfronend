$(function () {

	var $mobileNavWrapper = $('.mobile-nav-wrapper');
	var $mobileNavMenu = $mobileNavWrapper.find('.mobile-nav');

  /**
  * Mobile top nav hamburger menu
  */

  $('#mobile-top-nav-button').on('click touchstart', function (e) {
    e.stopPropagation();
    e.preventDefault();

    if ($mobileNavWrapper.is(':visible')) {
      $mobileNavWrapper.fadeOut('fast');
      $mobileNavMenu.removeClass('open');
      $('body').off('touchmove.mobileNav').removeClass('stop-scrolling');
    } else {
      $mobileNavWrapper.fadeIn('fast');
      $mobileNavMenu.addClass('open');

      // prevent page scroll
      $('body').on('touchmove.mobileNav', function (e) {
      	e.preventDefault();
      }).addClass('stop-scrolling');
    }
  });




  /**
  * Close sliding mobile nav menus
  */

  $mobileNavMenu.find('.close-x-black').on('click', function () {
    //if ($mobileNavWrapper.is(':visible')) {
      $mobileNavMenu.removeClass('open');
      setTimeout(function () {
      	$mobileNavWrapper.fadeOut('fast');
      }, 150);
      $('body').off('touchmove.mobileNav').removeClass('stop-scrolling');
    //}
  });

});