//= require jquery
//= require jquery_ujs
//= require classie
//= require fastclick
//= require gmaps
//= require owl.carousel
//= require jquery.tooltipster

$(function () {

  FastClick.attach(document.body);

  var $headerNav = $('#header .nav');
  var $window = $(window);

  // expandable top nav search
  var $searchForm = $('.nav-search');
  var $searchButton = $('.nav-search-button');
  var $searchInput = $('.nav-search-input');

  $searchInput.on('focus', function (e) {
    //alert('focus')
    e.stopPropagation();
  });

  $searchButton.on('click', function () {
    //alert('serach click');
    if ($searchForm.hasClass('open')) {
      $searchForm.removeClass('open')
    } else {
      $searchForm.addClass('open');
      $searchInput.focus();
    }
    return false;
  });

  // mobile top nav menu
  $('#mobile-top-nav-button').on('click', function (e) {
    //alert('mobile nav click')
    e.stopPropagation();
    e.preventDefault();

    if ($headerNav.is(':visible')) {
      $headerNav.slideUp('fast');
    } else {
      $headerNav.slideDown('fast');
    }
  });

  // window resize handler
  var windowWidth = $window.width(), windowHeight = $window.height();
  $window.on('resize', function () {
    if ($window.width() != windowWidth || $window.height != windowHeight) {
      alert('resize');

      windowWidth = $window.width();
      windowHeight = $window.height();
      
      $searchForm.removeClass('open');
      
      if ($window.width() > 1000) {
        $headerNav.show();
      } else {
        $headerNav.hide();
      }
    }
  });

  // hero carousel
  $('.hero-carousel').owlCarousel({
      navigation: false, // hide next and prev buttons
      slideSpeed: 300,
      pagination: false,
      paginationSpeed: 400,
      singleItem: true
  });

  // footer newsletter sign up
  $('.footer-newsletter-sign-up').on('submit', function () {
    var $form = $(this);

    $.ajax({
      method: 'POST',
      url: $form.attr('action'),
      data: $form.serialize()
    }).done(function(data) {
      if (data && data.success) {
        $form.find('input').val('').end().tooltipster('content', data.success).tooltipster('show');
      } else {
        $form.tooltipster('content', data.error).tooltipster('show');
      }
    });

    return false;
  });

  // footer tooltip init
  $('.footer-newsletter-sign-up').tooltipster({theme: 'tooltipster-noir', timer: 3000, trigger: 'foo'})

});