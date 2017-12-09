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
    } else {
      $mobileNavWrapper.fadeIn('fast');
      $mobileNavMenu.addClass('open');
    }
  });




  /**
  * Close sliding mobile nav menus
  */

  $mobileNavMenu.find('.close-x-black').on('click', function () {
    if ($mobileNavWrapper.is(':visible')) {
      $mobileNavMenu.removeClass('open');
      setTimeout(function () {
      	$mobileNavWrapper.fadeOut('fast');
      }, 150);
    } else {
      $mobileNavWrapper.fadeIn('fast');
      $mobileNavMenu.addClass('open');
    }
  });

});