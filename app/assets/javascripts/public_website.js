//= require jquery
//= require jquery_ujs
//= require jquery.widget
//= require disableSelection
//= require classie
//= require fastclick
//= require infobox
//= require gmaps
//= require owl.carousel
//= require jquery.tooltipster
//= require affix
//= require jquery.swipebox
//= require modal

$(function () {

  FastClick.attach(document.body);

  // size salon carousel before init
  // function sizeCarousel() {
  //   var $salonCarousel = $('.salon-carousel, .salon-pro-carousel');
  //   if ($salonCarousel.length) {
  //     $salonCarousel.find('img').css('height', $('.salon-info, .salon-pro-info').height() - 1);
  //   }
  // }

  // setTimeout(sizeCarousel, 100);

  // $(window).on('resize', sizeCarousel);

  // carousel
  $('.owl-carousel').each(function () {
    var $this = $(this);
    
    var options = {
      navigation: $this.data('nonav') ? false : true,
      navigationText: [
        "<i class='arrow-left'></i>",
        "<i class='arrow-right'></i>"
      ],
      slideSpeed: 300,
      pagination: false,
      autoPlay: 5000,
      transitionStyle : "fade"
    };

    if ($this.data('items')) {
      options['items'] = $this.data('items');
    } else {
      options['singleItem'] = true;
    }

    if ($this.data('animation')) {
      delete options['transitionStyle']; 
      options['animateOut'] = 'fadeOut'
    }

    if ($this.data('autoheight')) {
      options['autoHeight'] = true;
    }

    if ($this.data('autoplay')) {
      options['autoPlay'] = parseInt($this.data('autoplay'), 10);
    }

    if ($this.data('autoplayoff')) {
      options['autoPlay'] = false
    }

    $this.owlCarousel(options);
  });

  $(document.body).on('click', '.arrow-left, .arrow-right', function (e) {
    e.preventDefault();
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

  function openSearch() {
    $searchForm.addClass('open animating');
    $searchInput.focus();
    setTimeout(function () {
      $searchForm.removeClass('animating') 
    }, 500);
  }

  function closeSearch() {
    $searchForm.removeClass('open animating');
    $searchInput.val('').blur();
    $(document.body).click();
  } 

  $searchButton.on('click touchstart', function () {
    if ($searchForm.hasClass('open') && !$searchForm.hasClass('animating')) {
      closeSearch();
    } else {
      openSearch();
    }
    return false;
  });

  // mobile top nav menu
  $('#mobile-top-nav-button').on('click touchstart', function (e) {
    e.stopPropagation();
    e.preventDefault();

    if ($headerNav.is(':visible')) {
      $headerNav.slideUp('fast');
    } else {
      $headerNav.slideDown('fast');
    }
  });

  // play videos
  $('.play-button, .play-video').swipebox();

  // image-gallery
  $('.view-image-gallery').on('click', function () {
    var images = [];

    $('#image_gallery input').each(function () {
      images.push({href: $(this).val()});
    });

    $.swipebox(images);
    return false;
  });

  // $(document).on('click', '#swipebox-overlay', function (e) {
  //   $('#swipebox-close').trigger('click');
  // });

  // optgroup click handler
  $('.optgroup').on('click', function () {
    return false;
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

  // contact-us-request-a-tour
  $('#contact-us-request-a-tour').on('submit', function () {
    var $form = $(this);

    $.ajax({
      method: 'POST',
      url: $form.attr('action'),
      data: $form.serialize()
    }).done(function(data) {
      if (data && data.success) {
        $form.find('input').val('').blur().end().tooltipster('content', data.success).tooltipster('show');
      } else {
        $form.tooltipster('content', data.error).tooltipster('show');
      }
    });

    return false;
  });

  // contact-us-request-a-tour tooltip init
  $('#contact-us-request-a-tour').tooltipster({theme: 'tooltipster-noir', timer: 3000, trigger: 'foo'});

  // footer newsletter sign up
  $('.footer-newsletter-sign-up').on('submit', function () {
    var $form = $(this);

    $.ajax({
      method: 'POST',
      url: $form.attr('action'),
      data: $form.serialize()
    }).done(function(data) {
      if (data && data.success) {
        $form.find('input').val('').blur().end().tooltipster('content', data.success).tooltipster('show');
      } else {
        $form.tooltipster('content', data.error).tooltipster('show');
      }
    });

    return false;
  });

  // footer tooltip init
  $('.footer-newsletter-sign-up').tooltipster({theme: 'tooltipster-noir', timer: 3000, trigger: 'foo'});

  // request franchising info
  var $franchsing_modal = $('.request-franchising-modal').modal();

  // open send a message modal
  $('.request-franchising-info').on('click', function () {
    $franchsing_modal.data('modal').open();
    return false;
  });

  // form handler
  $('#franchising_request').on('submit', function () {
    var $form = $(this);

    $.ajax({
      method: 'POST',
      url: $form.attr('action'),
      data: $form.serialize()
    }).done(function(data) {
      if (data && data.success) {
        $form.find('input, textarea').val('').blur().end().tooltipster('content', data.success).tooltipster('show');
        setTimeout(function () {
          $franchsing_modal.data('modal').fadeOut();
        }, 3300);
      } else {
        $form.tooltipster('content', data.error).tooltipster('show');
      }
    });

    return false;
  });
  $('#franchising_request').tooltipster({theme: 'tooltipster-noir', timer: 3000, trigger: 'foo'});

});