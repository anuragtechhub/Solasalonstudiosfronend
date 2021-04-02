$(function () {

	/* solapro carousel */
  var currentSlideIndex = 0;
  var totalSlides = $('.sola-pro-phone-carousel').find('.item').length;
  $('.sola-pro-phone-carousel').each(function () {
    var $this = $(this);

    var options = {
      navigation: $this.data('nonav') ? false : true,
      navigationText: [
        "<i aria-label='Left' class='arrow-left' role='presentation'></i>",
        "<i aria-label='Right' class='arrow-right' role='presentation'></i>"
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

        // update solapro feature list
        $('.sola-pro-feature-list').find('li').removeClass('active')
        $('.sola-pro-feature-list').find('[data-slide="' + slide + '"]').addClass('active');

        // update solapro text
        $('.sola-pro-descriptions').find('div').not('.' + slide + '-text').hide();
        $('.sola-pro-descriptions').find('div.' + slide + '-text').show();
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
  var mc = new Hammer(document.getElementById('sola-pro-phone-gallery-wrapper'));
  mc.on('swiperight', function(ev) {
    if (currentSlideIndex == 0) {
      $('.sola-pro-phone-carousel').trigger('owl.jumpTo', totalSlides - 1);
    } else {
      $('.sola-pro-phone-carousel').trigger('owl.jumpTo', currentSlideIndex - 1);
    }
  });
  mc.on('swipeleft', function(ev) {
    if (currentSlideIndex + 1 == totalSlides) {
      $('.sola-pro-phone-carousel').trigger('owl.jumpTo', 0);
    } else {
      $('.sola-pro-phone-carousel').trigger('owl.jumpTo', currentSlideIndex + 1);
    }
  });

  /* solapro feature list */
  $('.sola-pro-feature-list-desktop li').on('click mouseenter', function () {
    var $this = $(this);

    $('.sola-pro-feature-list-desktop li').removeClass('active');
    $this.addClass('active');

    $('.sola-pro-phone-carousel').trigger('owl.jumpTo', $this.data('index'));

    return false;
  });

  AOS.init();

  /* solapro full screen section height */
  $(window).on('resize.solapro', function () {
    var $window = $(window);
    var $inner = $('#sola-pro-gallery-inner');
    var $videoControls = $('#solapro-video-controls');
    var $downCircleArrow = $('.down_circle_arrow_icon');
    var $heroTabs = $('.with-sola-pro');

    //console.log('$videoControls', $heroTabs.outerHeight(), $videoControls.offset().top);
    //console.log('resize Solapro', $inner.height(), $window.height());
    if ($inner.height() > $window.height()) {
      //console.log('content taller than window...');
      // content taller than window...
      $('#sola-pro-gallery').height($inner.height()+20);
      $inner.width($window.width()).css({top: 0, marginTop: 0});
    } else {
      //const value = document.documentElement.clientWidth > 550 ? '1160px' : '720px';
      $('#sola-pro-gallery').height('720px');
      $inner.width($window.width()).css({top: '50%', marginTop: -($inner.height() / 2) + 'px'});
    }

    /* solapro play button */
    //$videoControls.css({marginTop: -($videoControls.height() / 2), marginLeft: -($videoControls.width() / 2)});

    if (AOS && AOS.refresh) {
      AOS.refresh();
    }
  }).trigger('resize.solapro');

  setTimeout(function () {
    $(window).trigger('resize.solapro');
  }, 1);

});
