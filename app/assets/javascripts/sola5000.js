$(function () {
  $('.view-more').on('click', function () {
    if ($('.more').is(':visible')) {
      $('.more').fadeOut();
      $(this).html('View More')
    } else {
      $('.more').fadeIn();
      $(this).html('View Less')
    }
  });
});