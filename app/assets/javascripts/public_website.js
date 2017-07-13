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

$(function () {

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
      pagination: false,
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

    if ($this.data('pagination')) {
      options['pagination'] = true;
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

  // header and nav
  var $headerNav = $('#header .nav');
  var $window = $(window);

  // expandable top nav search
  var $searchForm = $('.nav-search');
  var $searchButton = $('.nav-search-button');
  var $searchInput = $('.nav-search-input');

  $searchInput.on('focus click', function (e) {
    e.stopPropagation();
  });

  function openSearch() {
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
  } 

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



  // 'oys' - own your salon nav
  var showOysNav = function () {
    if ($window.width() > 1000) {
      // desktop
      var $headerContainer = $('#header .container');
      $('.oys-nav').css({left: $headerContainer.offset().left, top: $headerContainer.outerHeight() + $('#top-header').outerHeight() - 1}).width($headerContainer.outerWidth()).show();
    }
  };

  $('.oys-nav-caret').on('click', function () {
    var $this = $(this);

    if ($this.hasClass('down')) {
      $this.removeClass('down').addClass('up');
      $('.oys-nav-mobile').slideDown('fast');
    } else {
      $this.removeClass('up').addClass('down');
      $('.oys-nav-mobile').slideUp('fast');
    }
  });

  $('#header .own_your_salon').on('mouseenter', function () {
    //showOysNav();
  }).hoverIntent({
    over: function () {
      showOysNav();
    }, 
    out: function () {
      var $oysNav = $('.oys-nav');

      if ($oysNav.hasClass('over')) {
        // shhh...
      } else {
        $oysNav.hide();
      }
    },
    timeout: 500
  });

  $('.oys-nav').on('mouseenter', function () {
    $('.oys-nav').addClass('over').show();
  });  

  $('.oys-nav').on('mouseleave', function () {
    $('.oys-nav').removeClass('over').hide();
  }); 

  $(window).on('resize.oysNav', function () {
    if ($(window).width() > 1000) {
      // desktop
      $('.oys-nav-mobile').hide();
      $('#header .nav .caret').removeClass('up').addClass('down');
    }
  }).trigger('resize.oysNav');



  // play videos
  $('.play-button, .play-video').swipebox();

  /* country-switcher */
  $(document.body).on('click', '.country-switcher:not(.country-switcher-modal)', function () {
    var $this = $(this);

    $('.country-switcher-modal').css({top: $this.offset().top + 30, left: $this.offset().left}).show();

    $(document.body).on('click.country-switcher-open', function () {
      $('.country-switcher-modal').hide();
      $(document.body).off('click.country-switcher-open');
    });

    return false;
  });

  $(document.body).on('click', '.country-switcher-modal .country', function () {
    var $this = $(this);
    var domain = getDomain(location.href);

    if ($this.data('domain') == 'ca' && domain.startsWith('com')) {
      window.location.href = "https://www.solasalonstudios.ca" + domain.substring(3, domain.length);
    }

    if ($this.data('domain') == 'com' && domain.startsWith('ca')) {
      window.location.href = "https://www.solasalonstudios.com" + domain.substring(2, domain.length);
    }

    $('.country-switcher-modal').hide();
    $(document.body).off('click.country-switcher-open');    
  });

  $(window).on('resize.countryswitcher', function () {
    $('.country-switcher-modal').hide();
  });

  var TLDs = ["ac", "ad", "ae", "aero", "af", "ag", "ai", "al", "am", "an", "ao", "aq", "ar", "arpa", "as", "asia", "at", "au", "aw", "ax", "az", "ba", "bb", "bd", "be", "bf", "bg", "bh", "bi", "biz", "bj", "bm", "bn", "bo", "br", "bs", "bt", "bv", "bw", "by", "bz", "ca", "cat", "cc", "cd", "cf", "cg", "ch", "ci", "ck", "cl", "cm", "cn", "co", "com", "coop", "cr", "cu", "cv", "cx", "cy", "cz", "de", "dj", "dk", "dm", "do", "dz", "ec", "edu", "ee", "eg", "er", "es", "et", "eu", "fi", "fj", "fk", "fm", "fo", "fr", "ga", "gb", "gd", "ge", "gf", "gg", "gh", "gi", "gl", "gm", "gn", "gov", "gp", "gq", "gr", "gs", "gt", "gu", "gw", "gy", "hk", "hm", "hn", "hr", "ht", "hu", "id", "ie", "il", "im", "in", "info", "int", "io", "iq", "ir", "is", "it", "je", "jm", "jo", "jobs", "jp", "ke", "kg", "kh", "ki", "km", "kn", "kp", "kr", "kw", "ky", "kz", "la", "lb", "lc", "li", "lk", "lr", "ls", "lt", "lu", "lv", "ly", "ma", "mc", "md", "me", "mg", "mh", "mil", "mk", "ml", "mm", "mn", "mo", "mobi", "mp", "mq", "mr", "ms", "mt", "mu", "museum", "mv", "mw", "mx", "my", "mz", "na", "name", "nc", "ne", "net", "nf", "ng", "ni", "nl", "no", "np", "nr", "nu", "nz", "om", "org", "pa", "pe", "pf", "pg", "ph", "pk", "pl", "pm", "pn", "pr", "pro", "ps", "pt", "pw", "py", "qa", "re", "ro", "rs", "ru", "rw", "sa", "sb", "sc", "sd", "se", "sg", "sh", "si", "sj", "sk", "sl", "sm", "sn", "so", "sr", "st", "su", "sv", "sy", "sz", "tc", "td", "tel", "tf", "tg", "th", "tj", "tk", "tl", "tm", "tn", "to", "tp", "tr", "travel", "tt", "tv", "tw", "tz", "ua", "ug", "uk", "us", "uy", "uz", "va", "vc", "ve", "vg", "vi", "vn", "vu", "wf", "ws", "xn--0zwm56d", "xn--11b5bs3a9aj6g", "xn--3e0b707e", "xn--45brj9c", "xn--80akhbyknj4f", "xn--90a3ac", "xn--9t4b11yi5a", "xn--clchc0ea0b2g2a9gcd", "xn--deba0ad", "xn--fiqs8s", "xn--fiqz9s", "xn--fpcrj9c3d", "xn--fzc2c9e2c", "xn--g6w251d", "xn--gecrj9c", "xn--h2brj9c", "xn--hgbk6aj7f53bba", "xn--hlcj6aya9esc7a", "xn--j6w193g", "xn--jxalpdlp", "xn--kgbechtv", "xn--kprw13d", "xn--kpry57d", "xn--lgbbat1ad8j", "xn--mgbaam7a8h", "xn--mgbayh7gpa", "xn--mgbbh1a71e", "xn--mgbc0a9azcg", "xn--mgberp4a5d4ar", "xn--o3cw4h", "xn--ogbpf8fl", "xn--p1ai", "xn--pgbs0dh", "xn--s9brj9c", "xn--wgbh1c", "xn--wgbl6a", "xn--xkc2al3hye2a", "xn--xkc2dl3a5ee0h", "xn--yfro4i67o", "xn--ygbi2ammx", "xn--zckzah", "xxx", "ye", "yt", "za", "zm", "zw"].join()

  function getDomain(url){

      var parts = url.split('.');
      if (parts[0] === 'www' && parts[1] !== 'com'){
          parts.shift()
      }
      var ln = parts.length
        , i = ln
        , minLength = parts[parts.length-1].length
        , part

      // iterate backwards
      while(part = parts[--i]){
          // stop when we find a non-TLD part
          if (i === 0                    // 'asia.com' (last remaining must be the SLD)
              || i < ln-2                // TLDs only span 2 levels
              || part.length < minLength // 'www.cn.com' (valid TLD as second-level domain)
              || TLDs.indexOf(part) < 0  // officialy not a TLD
          ){
              return part
          }
      }
  }

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
        $form.tooltipster({theme: 'tooltipster-noir', timer: 3000, trigger: 'foo'}).tooltipster('content', data.error).tooltipster('show');
      }
    });

    return false;
  });

  // contact-us-request-a-tour tooltip init
  if (window.location.pathname.indexOf('/contact-us-success') != -1) {
    $('#contact-us-request-a-tour').tooltipster({theme: 'tooltipster-noir', timer: 3000, trigger: 'foo'}).tooltipster('content', 'Thank you! We will get in touch soon').tooltipster('show');
    // setTimeout(function () {
    //   window.location.hash = '#rent-a-studio';
    // }, 3000);
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