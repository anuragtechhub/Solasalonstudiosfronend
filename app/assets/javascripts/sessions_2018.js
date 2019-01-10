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

  // animated scroll
  $('a[href*="#"]:not([href="#"])').click(function() {
    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
      if (target.length) {
        $('html, body').animate({
          scrollTop: target.offset().top
        }, 1000);
        return false;
      }
    }
  });

  // featured presenter modals
  function initModals() {
    $('.bio').modal();
  }
  initModals();

  // $(document).on('click', '.speakers .columns', function () {
  //   var id = $(this).data('rel');
  //   if (id) {
  //     $('.bio[data-rel=' + id + ']').data('modal').open();
  //   }
  //   return false;
  // });

  $(document).on('click', '.modal-header .company a', function () {
    return false;
  });

  // custom scroll
  $('.modal .content').mCustomScrollbar({
    theme: "minimal-light",
    alwaysShowScrollbar: 1,
    autoHideScrollbar: true,
  });

  $('.add-to-calendar-wrapper').add_to_calendar();

});