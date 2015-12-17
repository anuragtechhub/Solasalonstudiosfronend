$(function () {

  var scrollTop = 0;

  $('#showBios').on('click', function () {
    scrollTop = $(document.body).scrollTop();
    $('.bios').slideDown(function () {
      $('#showBios').hide();
      $('#hideBios').show();
    });
  });

  $('#hideBios').on('click', function () {
    $('.bios').slideUp(function () {
      $('#hideBios').hide();
      $('#showBios').show();
    });
    $(document.body).animate({scrollTop: scrollTop});
  });

});