// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function () {

  // visibility check (to hide owl-carousel-poster)

  setInterval(function () {
    $('.hero-tab-content').each(function () {
      var $this = $(this);

      if ($this.is(':visible') && $this.find('.owl-carousel-poster').is(':visible')) {
        $this.find('.owl-carousel-poster').fadeOut(2000);
      }
    });
  }, 200);

  /* amenities dots */

  $('.dot').each(function () {
    var $this = $(this);
    $this.tooltipster({theme: 'tooltipster-hughes', content: $($this.data('tooltip'))});
  });

  /* tabs */

  $('.hero-tabs a').on('click', function () {
    var href = $(this).attr('href').slice(1);

    $('.hero-tab-content').hide().filter('[data-ref=#' + href + ']').show();
    window.history.pushState(null, null, '/own-new/' + href);

    return false;
  });

});