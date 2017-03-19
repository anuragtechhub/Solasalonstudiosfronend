$(function () {

  /* amenities dots */
  $('.dot').not('.no-tooltip').each(function () {
    var $this = $(this);
    $this.tooltipster({theme: 'tooltipster-hughes', content: $($this.data('tooltip'))});
  });

  $('.hero-fullscreen .dot').on('click', function () {
    var $this = $(this);
    
    $('.hero-fullscreen .dot').removeClass('active');
    $this.addClass('active');
    $('#amenity-description').html($this.data('html'));
  });

  /* tabs */
  $('.hero-tabs a').on('click', function () {
    var $this = $(this);
    var href = $this.attr('href').slice(1);

    $('.hero-tab-content').removeClass('hero-active').filter('[data-ref=#' + href + ']').addClass('hero-active');
    window.history.pushState(null, null, $this.data('base') + href);

    if (AOS && AOS.refresh) {
      AOS.refresh();
    }

    return false;
  });

  /* placeholder text toggle */
  $('input[data-placeholder-focus][data-placeholder-blur]').focus(function() {
    var $this = $(this);
    $this.attr('placeholder', $this.data('placeholder-focus'));
  }).blur(function() {
    var $this = $(this);
    $this.attr('placeholder', $this.data('placeholder-blur'));
  });

  /* down arrow scroll animation */
  $('.down_circle_arrow_icon').on('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    var $anchor = $($(this).attr('href'));
    $('html, body').animate({scrollTop: $anchor.offset().top}, 'normal');
    return false;
  });

  /* solagenius carousel */
  var currentSlideIndex = 0;
  var totalSlides = $('.sola-genius-phone-carousel').find('.item').length;
  $('.sola-genius-phone-carousel').each(function () {
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
      //autoPlay: 7000,
      transitionStyle : "fade",
      afterMove: function (carousel) {
        currentSlideIndex = this.currentItem;
        var slide = this.wrapperOuter.find('.item:eq(' + this.currentItem + ')').data('slide');
        //console.log('afterMove', slide, this.currentItem);

        // update solagenius feature list
        $('.sola-genius-feature-list').find('li').removeClass('active')
        $('.sola-genius-feature-list').find('[data-slide="' + slide + '"]').addClass('active');

        // update solagenius text
        $('.sola-genius-descriptions').find('div').not('.' + slide + '-text').hide();
        $('.sola-genius-descriptions').find('div.' + slide + '-text').show();
      }
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

    //if ($this.data('pagination')) {
      options['pagination'] = true;
    //}

    if ($this.data('nonav')) {
      options['nav'] = false;
    }

    $this.owlCarousel(options);
  });

  /* swipe left/right */
  var mc = new Hammer(document.getElementById('sola-genius-phone-gallery-wrapper'));
  mc.on('swiperight', function(ev) {
    if (currentSlideIndex == 0) {
      $('.sola-genius-phone-carousel').trigger('owl.jumpTo', totalSlides - 1);
    } else {
      $('.sola-genius-phone-carousel').trigger('owl.jumpTo', currentSlideIndex - 1);
    }
  });
  mc.on('swipeleft', function(ev) {
    if (currentSlideIndex + 1 == totalSlides) {
      $('.sola-genius-phone-carousel').trigger('owl.jumpTo', 0);
    } else {
      $('.sola-genius-phone-carousel').trigger('owl.jumpTo', currentSlideIndex + 1);
    }
  });

  /* solagenius feature list */
  $('.sola-genius-feature-list-desktop li').on('click mouseenter', function () {
    var $this = $(this);

    $('.sola-genius-feature-list-desktop li').removeClass('active');
    $this.addClass('active');

    $('.sola-genius-phone-carousel').trigger('owl.jumpTo', $this.data('index'));

    return false;
  });

  AOS.init();

  /* solagenius full screen section height */
  $(window).on('resize.solagenius', function () {
    var $window = $(window);
    var $inner = $('#sola-genius-gallery-inner');
    var $videoControls = $('#solagenius-video-controls');
    var $downCircleArrow = $('.down_circle_arrow_icon');
    var $heroTabs = $('.with-sola-genius');

    //console.log('$videoControls', $heroTabs.outerHeight(), $videoControls.offset().top);
    //console.log('resize SolaGenius', $inner.height(), $window.height());
    if ($inner.height() > $window.height()) {
      //console.log('content taller than window...');
      // content taller than window...
      $('#sola-genius-gallery').height($inner.height());
      $inner.width($window.width()).css({top: 0, marginTop: 0});
    } else {
      //console.log('default...');
      // default
      $('#sola-genius-gallery').height($window.height());
      $inner.width($window.width()).css({top: '50%', marginTop: -($inner.height() / 2) + 'px'});
    }

    /* solagenius play button */
    //$videoControls.css({marginTop: -($videoControls.height() / 2), marginLeft: -($videoControls.width() / 2)});

    if (AOS && AOS.refresh) {
      AOS.refresh();
    }
  }).trigger('resize.solagenius');
  
  setTimeout(function () {
    $(window).trigger('resize.solagenius');
  }, 1);

});