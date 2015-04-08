//= require jquery
//= require jquery_ujs
//= require classie
//= require fastclick
//= require infobox
//= require gmaps
//= require owl.carousel
//= require jquery.tooltipster

$(function () {

  FastClick.attach(document.body);

  // size salon carousel before init
  var $salonCarousel = $('.salon-carousel, .salon-pro-carousel');
  if ($salonCarousel.length) {
    $salonCarousel.find('img').css('max-height', $('.salon-info, .salon-pro-info').height() - 1);
  }

  // carousel
  $('.owl-carousel').owlCarousel({
      navigation: true,
      navigationText: [
        "<i class='arrow-left'></i>",
        "<i class='arrow-right'></i>"
      ],
      slideSpeed: 300,
      pagination: false,
      paginationSpeed: 400,
      autoPlay: 5000,
      singleItem: true,
      transitionStyle : "fade"
  });

  // header and nav
  var $headerNav = $('#header .nav');
  var $window = $(window);

  // expandable top nav search
  var $searchForm = $('.nav-search');
  var $searchButton = $('.nav-search-button');
  var $searchInput = $('.nav-search-input');

  $searchInput.on('focus', function (e) {
    e.stopPropagation();
  });

  $searchButton.on('click', function () {
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
    if ($window.width() != windowWidth && $window.height != windowHeight) {
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