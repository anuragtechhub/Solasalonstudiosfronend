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
    var href = $(this).attr('href').slice(1);

    $('.hero-tab-content').removeClass('hero-active').filter('[data-ref=#' + href + ']').addClass('hero-active');
    window.history.pushState(null, null, '/own/' + href);

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
