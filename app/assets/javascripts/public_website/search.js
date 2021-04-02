$(function () {

 	var $headerNav = $('#header .nav');
  var $window = $(window);
  var $searchForm = $('.nav-search');
  var $searchInput = $('.nav-search-input');
	var $mobileSearchModal = $('.mobile-search-modal');



  /**
  * Clickable search results
  */
  $('.search-result-clickable .bold-link, .search-result-clickable .book-now-button').on('click', function (e) {
    e.stopPropagation();
  });

  $('.search-result-clickable').on('click', function () {
    if ($(this).data('href')) {
      window.location.href = $(this).data('href');
    }
  });



  /**
  * Expandable top nav search
 	*/

  $searchInput.on('focus click', function (e) {
    e.stopPropagation();
  });

  $('.nav-search-button').on('click touchstart keyup', function (e) {
    if (e.type === 'keyup' && e.keyCode !== 13) {
      return false;
    }

  	if ($window.width() > 1000) {
  		// desktop
	    if ($searchForm.hasClass('open') && !$searchForm.hasClass('animating') && $searchInput.val() == '') {
	      closeSearch();
	    } else if ($searchForm.hasClass('open') && !$searchForm.hasClass('animating') && $searchInput.val() != '') {
	      $searchForm.trigger('submit');
	    } else {
	      openSearch();
	    }
	  } else {
	  	// mobile search
	  	if ($mobileSearchModal.hasClass('open')) {
	  		$mobileSearchModal.fadeOut('fast', function () {
	  			$mobileSearchModal.removeClass('open');
	  		});
        $('body').off('touchmove.mobileSearch').removeClass('stop-scrolling');
	  	} else {
	  		$mobileSearchModal.fadeIn('fast', function () {
	  			$mobileSearchModal.addClass('open');
	  		});
        // prevent page scroll
        $('body').on('touchmove.mobileSearch', function (e) {
          e.preventDefault();
        }).addClass('stop-scrolling');
	  	}
	  }
    return false;
  });



  /**
  * Close mobile search
  */
  $('.mobile-search-modal .close-x-white').on('click', function () {
    $mobileSearchModal.fadeOut('fast', function () {
      $mobileSearchModal.removeClass('open');
    });
    $('body').off('touchmove.mobileSearch').removeClass('stop-scrolling');
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

  	if ($mobileSearchModal.hasClass('open')) {
  		$mobileSearchModal.fadeOut('fast', function () {
  			$mobileSearchModal.removeClass('open');
  		});
  	}
    $('body').off('touchmove.mobileSearch').removeClass('stop-scrolling');
  }

});