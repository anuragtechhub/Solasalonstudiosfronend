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
  $('.down_circle_arrow_icon').on('click', function () {
    var $anchor = $($(this).attr('href'));
    $('html, body').animate({scrollTop: $anchor.offset().top}, 'normal');
    return false;
  });

  /* solagenius carousel */
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
      //autoPlay: 5000,
      transitionStyle : "fade",
      afterMove: function (carousel) {
        var slide = this.wrapperOuter.find('.item:eq(' + this.currentItem + ')').data('slide');
        //console.log('afterMove', slide, this.currentItem);

        // update feature list
        $('.sola-genius-feature-list').find('li').removeClass('active')
        $('.sola-genius-feature-list').find('[data-slide="' + slide + '"]').addClass('active');

        // update text
        $('.sola-genius-descriptions').find('p').not('.' + slide + '-text').fadeOut();
        $('.sola-genius-descriptions').find('p.' + slide + '-text').fadeIn();
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

    if ($this.data('pagination')) {
      options['pagination'] = true;
    }

    if ($this.data('nonav')) {
      options['nav'] = false;
    }

    $this.owlCarousel(options);
  });

  /* solagenius feature list */
  $('.sola-genius-feature-list-desktop li').on('click', function () {
    var $this = $(this);

    $('.sola-genius-feature-list-desktop li').removeClass('active');
    $this.addClass('active');

    $('.sola-genius-phone-carousel').trigger('owl.goTo', $this.data('index'));

    return false;
  });

  AOS.init();

});