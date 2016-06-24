// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$(function () {

  // visibility check (to hide owl-carousel-poster)

  // setInterval(function () {
  //   $('.hero-tab-content').each(function () {
  //     var $this = $(this);

  //     if ($this.is(':visible') && $this.find('.owl-carousel-poster').is(':visible')) {
  //       $this.find('.owl-carousel-poster').fadeOut(2000);
  //     }
  //   });
  // }, 200);

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
    var href = $(this).attr('href').slice(1);

    $('.hero-tab-content').hide().filter('[data-ref=#' + href + ']').show();
    window.history.pushState(null, null, '/own-new/' + href);

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

});