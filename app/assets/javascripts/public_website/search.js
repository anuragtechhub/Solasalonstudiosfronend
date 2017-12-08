$(function () {
	
  /**
  * Expandable top nav search
 	*/
  var $searchForm = $('.nav-search');
  var $searchButton = $('.nav-search-button');
  var $searchInput = $('.nav-search-input');

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