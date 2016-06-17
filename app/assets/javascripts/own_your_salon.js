// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function () {

  $('.dot').each(function () {
    var $this = $(this);
    $this.tooltipster({theme: 'tooltipster-hughes', content: $($this.data('tooltip'))});
  });

  $('.hero-tabs a').on('click', function () {
    $('.hero-tab-content').hide().filter('[data-ref=' + $(this).attr('href') + ']').show();
    return false;
  });

});