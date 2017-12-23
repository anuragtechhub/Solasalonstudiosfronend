//= require application
//= require jquery.widget
//= require modernizr
//= require disableSelection
//= require classie
//= require infobox
//= require gmaps
//= require owl.carousel
//= require jquery.tooltipster
//= require affix
//= require jquery.swipebox
//= require modal
//= require jquery.mousewheel
//= require jquery.mCustomScrollbar
//= require jssocials
//= require aos
//= require hammer
//= require text-gradient-default
//= require text-gradient-svg
//= require text-gradient
//= require jquery.hoverIntent
//= require add_to_calendar
//= require_tree ./public_website

$(function () {

  $('.sola-select').solaselect();

  // carousel
  $('.owl-carousel').not('.no-autobind').each(function () {
    var $this = $(this);
    
    var options = {
      navigation: $this.data('nonav') ? false : true,
      navigationText: [
        "<i class='arrow-left'></i>",
        "<i class='arrow-right'></i>"
      ],
      lazyEffect: false,
      slideSpeed: 300,
      pagination: true,
      //autoPlay: 5000,
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

    if ($this.data('paginationoff')) {
      options['pagination'] = false;
    }

    if ($this.data('nonav')) {
      options['nav'] = false;
    }

    $this.owlCarousel(options);
  });

  $(document.body).on('click', '.arrow-left, .arrow-right', function (e) {
    e.preventDefault();
  });

  // show hero carousel images (to minimize page bounce)
  $('.hero-carousel .item').show();

  var $window = $(window);

  // play videos
  $('.play-button, .play-video').swipebox();

  // filterable dropdown searchboxes
  $('.filterable-dropdown-search').filterabledropdownsearch();

  // optgroup click handler
  $('.optgroup').on('click', function () {
    return false;
  });

  // animated scrolling
  $(document.body).on('click', '[data-animated-scroll]', function () {
    var $this = $(this);

    // scroll to anchor
    if ($this.data('height-offset')) {
      var heightOffset = $($this.data('height-offset')).outerHeight() + 15;
      $('html, body').animate({scrollTop: $($this.attr('href')).offset().top - heightOffset}, 'slow');
    } else {
      $('html, body').animate({scrollTop: $($this.attr('href')).offset().top}, 'slow');
    }

    // update .active class
    $('[data-nav-group="' + $this.data('nav-group') + '"]').removeClass('active').filter('[href="' + $this.attr('href') + '"]').addClass('active');
    
    return false;
  });

  // sticky menu
  window.initStickyMenu = function () {
    var $sticky = $('.sticky');
    if (!!$sticky.offset()) { // make sure ".sticky" element exists

      var generalSidebarHeight = $sticky.innerHeight();
      var stickyTop = $sticky.offset().top;
      var stickOffset = 0;

      $(window).on('resize.sticky', function () {
        var windowWidth = $(window).width();

        if (windowWidth < 750) {
          $(window).off('scroll.sticky');
          $sticky.css({position: 'static'});
        } else {
          $(window).on('scroll.sticky', function () { // scroll event
            var windowTop = $(window).scrollTop(); // returns number

            if (stickyTop < windowTop + stickOffset) {
              $sticky.css({position: 'fixed', top: stickOffset});
            } else {
              $sticky.css({position: 'absolute', top: 'initial'});
            }

            $sticky.find('a').each(function () {
              var scrollPos = $(document).scrollTop();
              var currLink = $(this);
              var refElement = $(currLink.attr("href"));
              
              if (refElement.offset().top <= scrollPos && refElement.offset().top + refElement.next('div').outerHeight() > scrollPos) {
                $sticky.find('a').removeClass("active");
                currLink.addClass("active");
              }
              else {
                currLink.removeClass("active");
              }

              // handle first and last links
              var $firstLink = $sticky.find('a').first();//.attr('href');
              var $lastLink = $sticky.find('a').last();

              // handle first link
              if ($($firstLink.attr('href')).offset().top >= scrollPos) {
                $sticky.find('a').removeClass("active");
                $firstLink.addClass("active");
              }

              // handle last link
              if ($($lastLink.attr('href')).offset().top <= scrollPos || $(window).scrollTop() + $(window).height() == $(document).height()) {
                $sticky.find('a').removeClass("active");
                $lastLink.addClass("active");
              }
            });

          });
        }
      });

      $(window).trigger('resize.sticky');
    }  
  };
  window.initStickyMenu();

  // sessions mobile nav and menu
  var $sessionsMobileMenu = $('.sessions-mobile-menu');
  var $sessionsMobileNav  = $('.sessions-mobile-nav');

  if ($sessionsMobileMenu.length && $sessionsMobileNav.length) {

    // hamburger toggle handler
    $sessionsMobileMenu.find('.fa').on('click', function () {
      $sessionsMobileNav.show();
      return false;
    });

    // close handler
    $sessionsMobileNav.find('.close .fa').on('click', function () {
      $sessionsMobileNav.hide();
      return false;
    });
    
    // window resize handler
    $(window).on('resize.sessionsMobile', function () {
      var winWidth = $(window).width();

      if (winWidth <= 750) {
        $(window).on('scroll.sessionsMobile', function () {
          var aboutTop = $('#About').offset().top - 60;
          var windowTop = $(window).scrollTop();

          if (windowTop >= aboutTop) {
            $sessionsMobileMenu.show();
          } else {
            //$sessionsMobileNav.hide();
            $sessionsMobileMenu.hide();
          }
        });
        
        $(window).trigger('scroll.sessionsMobile');
      } else {
        $(window).off('scroll.sessionsMobile');
        $sessionsMobileMenu.hide();
        $sessionsMobileNav.hide();
      }
    });

    $(window).trigger('resize.sessionsMobile');
  }

  // contact-us-request-a-tour
  $('#contact-us-request-a-tour').on('submit', function () {
    var $form = $(this);

    $('#contact-us-request-a-tour-submit').hide();
    $('#contact-us-request-a-tour-submitting').show();

    $.ajax({
      method: 'POST',
      url: $form.attr('action'),
      data: $form.serialize()
    }).done(function(data) {
      if (data && data.success) {
        var path = window.location.pathname;
        if (path.indexOf('contact-us-success') == -1) {
          path = path + '/contact-us-success';
        }
        window.history.pushState(null, null, path);
        // window.location.hash = 'contact-us-success'
        window.location.reload();
        //$form.find('input, textarea').val('').blur().end().tooltipster('content', data.success).tooltipster('show');
      } else {
        $('#contact-us-request-a-tour-submit').show();
        $('#contact-us-request-a-tour-submitting').hide();
        $form.tooltipster({theme: 'tooltipster-noir', timer: 3000, trigger: 'foo'}).tooltipster('content', data.error).tooltipster('show');
      }
    });

    return false;
  });

  // contact-us-request-a-tour tooltip init
  if (window.location.pathname.indexOf('/contact-us-success') != -1) {
    $('#contact-us-request-a-tour').tooltipster({theme: 'tooltipster-noir', timer: 3000, trigger: 'foo'}).tooltipster('content', 'Thank you! We will get in touch soon').tooltipster('show');
  }
  

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

  // refresh recaptcha
  function refreshCaptcha() {
    if (grecaptcha && typeof grecaptcha.reset === 'function') {
      grecaptcha.reset();
    }
  }

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

    if ($('#g-recaptcha-response').val() !== '') {
      $.ajax({
        method: 'POST',
        url: $form.attr('action'),
        data: $form.serialize()
      }).done(function(data) {
        refreshCaptcha();
        if (data && data.success) {
          $form.find('input, textarea').val('').blur().end().tooltipster('content', data.success).tooltipster('show');
          setTimeout(function () {
            $franchsing_modal.data('modal').fadeOut();
          }, 3300);
        } else {
          $form.tooltipster('content', data.error).tooltipster('show');
        }
      });

    } else {
      $form.tooltipster('content', 'No robots allowed. Please check the box to prove you are a human').tooltipster('show');
    }

    return false;
  });

  $('#franchising_request').tooltipster({theme: 'tooltipster-noir', timer: 3000, trigger: 'foo'});

  // gradient text
  $('h2.gradient').each(function () {
    new TextGradient($(this)[0], {
      from : '#79c7fb',
      to : '#e157f9',                                                          
      direction : 'right'
    });
  });  

});