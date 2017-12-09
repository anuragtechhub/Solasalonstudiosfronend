$(function () {

	var $mobileNavWrapper = $('.mobile-nav-wrapper');
	var $mobileNavMenu = $mobileNavWrapper.find('.mobile-nav');

  /**
  * Mobile top nav hamburger menu
  */

  $('#mobile-top-nav-button').on('click touchstart', function (e) {
    e.stopPropagation();
    e.preventDefault();

    $

    if ($mobileNavWrapper.is(':visible')) {
      $mobileNavWrapper.fadeOut('fast');
    } else {
      $mobileNavWrapper.fadeIn('fast');
    }
  });




  /**
  * Sliding mobile nav menus
  */

  


});