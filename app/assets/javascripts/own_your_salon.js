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

  /* solagenius gallery */
  $('.sola-genius-feature-list-desktop li').on('click', function () {
    var $this = $(this);

    $('.sola-genius-feature-list-desktop li').removeClass('active');
    $this.addClass('active');

    return false;
  });

  /* init "animate-on-scoll" */
  AOS.init();

});