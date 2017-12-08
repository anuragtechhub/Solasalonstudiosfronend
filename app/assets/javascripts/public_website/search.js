$(function () {
	
 	var $headerNav = $('#header .nav');
  var $window = $(window);
  var $searchForm = $('.nav-search');
  var $searchButton = $('.nav-search-button');
  var $searchInput = $('.nav-search-input');



  /**
  * Expandable top nav search
 	*/

  $searchInput.on('focus click', function (e) {
    e.stopPropagation();
  });

  $searchButton.on('click touchstart', function () {
    if ($searchForm.hasClass('open') && !$searchForm.hasClass('animating') && $searchInput.val() == '') {
      closeSearch();
    } else if ($searchForm.hasClass('open') && !$searchForm.hasClass('animating') && $searchInput.val() != '') {
      $searchForm.trigger('submit');
    } else {
      openSearch();
    }
    return false;
  });



  /**
  * Mobile top nav hamburger menu
  */

  $('#mobile-top-nav-button').on('click touchstart', function (e) {
    e.stopPropagation();
    e.preventDefault();

    if ($headerNav.is(':visible')) {
      $headerNav.slideUp('fast');
    } else {
      $headerNav.slideDown('fast');
    }
  });



  /**
  * Window resize handler
  */

  var windowWidth = $window.width(), windowHeight = $window.height();
  $window.on('resize', function () {
    if ($window.width() != windowWidth && $window.height != windowHeight) {
      windowWidth = $window.width();
      windowHeight = $window.height();
      
      closeSearch();
      
      if ($window.width() > 1000) {
        $headerNav.show();
      } else {
        $headerNav.hide();
      }
    }
  });



  /**
  * Helper functions
  */

  function openSearch() {
  	$searchInput.css('background', '#FFF');
    $searchForm.addClass('open animating');
    $searchInput.focus();
    $(document.body).on('click.search', closeSearch);
    setTimeout(function () {
      $searchForm.removeClass('animating') 
    }, 400);
  }

  function closeSearch() {
    $searchForm.removeClass('open animating');
    $searchInput.val('').blur();
    $(document.body).off('click.search').click();
    setTimeout(function () {
      $searchInput.css('background', 'transparent'); 
    }, 150);
  } 

});