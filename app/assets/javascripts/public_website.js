//= require jquery
//= require jquery_ujs
//= require classie
//= require search
//= require gmaps

$(function () {

  var $headerNav = $('#header .nav');
  var $window = $(window);

  // expandable search
  var uiSearch = new UISearch( document.getElementById('sb-search'));

  // mobile top nav menu
  $('#mobile-top-nav-button').on('click', function () {
    

    if ($headerNav.is(':visible')) {
      $headerNav.slideUp('fast');
    } else {
      $headerNav.slideDown('fast');
    }

    return false;
  });

  // window resize handler
  $window.on('resize', function () {
    // if (uiSearch && typeof uiSearch.close === 'function') {
    //   console.log('close')
    //   uiSearch.close();
    // }
    $('#sb-search').removeClass('sb-search-open');
    if ($window.width() > 1000) {
      $headerNav.show();
    } else {
      $headerNav.hide();
    }
  });

});