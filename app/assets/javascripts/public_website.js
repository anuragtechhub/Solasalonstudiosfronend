//= require jquery
//= require jquery_ujs
//= require classie
//= require fastclick
//= require search
//= require gmaps
//= require owl.carousel

$(function () {

  FastClick.attach(document.body);

  var $headerNav = $('#header .nav');
  var $search = $('#search');
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

  $('#sb-icon-search').on('click', function () {
    $search.focus();
  });

  // window resize handler
  $window.on('resize', function () {
    $('#sb-search').removeClass('sb-search-open');
    if ($window.width() > 1000) {
      $headerNav.show();
    } else {
      $headerNav.hide();
    }
  });

  $('.hero-carousel').owlCarousel({
      navigation: false, // hide next and prev buttons
      slideSpeed: 300,
      pagination: false,
      paginationSpeed: 400,
      singleItem: true
 
      // "singleItem:true" is a shortcut for:
      // items : 1, 
      // itemsDesktop : false,
      // itemsDesktopSmall : false,
      // itemsTablet: false,
      // itemsMobile : false
  });

});