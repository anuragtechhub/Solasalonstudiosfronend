$(function () {

  /*
  * Open/Close country switcher modal when clicking country in top nav
  */

  $(document.body).on('click keyup', '.country-switcher:not(.country-switcher-modal)', function (e) {
    if (e.type === 'click' || (e.type === 'keyup' && e.keyCode === 13)) {
      var $this = $(this);

      if ($('.country-switcher-modal').is(':visible')) {
        // hide modal
        $('.country-switcher-modal').hide();
        $(document.body).off('click.country-switcher-open');
      } else {
        // show modal
        $('.country-switcher-modal').css({top: $this.offset().top + 30, left: $this.offset().left}).show();

        $(document.body).on('click.country-switcher-open', function () {
          $('.country-switcher-modal').hide();
          $(document.body).off('click.country-switcher-open');
        });
      }

      return false;
    }
  });

  /*
  * Switch countries when clicking country in country switcher modal
  */

  $(document.body).on('click keyup', '.country-switcher-modal .country', function (e) {
    if (e.type === 'click' || (e.type === 'keyup' && e.keyCode === 13)) {
      var $this = $(this);

      if ($this.data('domain') == 'ca') {
        window.location.href = "https://www.solasalonstudios.ca" + location.pathname + location.search + location.hash;
      }

      if ($this.data('domain') == 'com.br') {
        window.location.href = "https://www.solasalonstudios.com.br" + location.pathname + location.search + location.hash;
      }

      if ($this.data('domain') == 'com') {
        window.location.href = "https://www.solasalonstudios.com" + location.pathname + location.search + location.hash;
      }

      $('.country-switcher-modal').hide();
      $(document.body).off('click.country-switcher-open');
    }
  });

  /*
  * Hide open country switcher modal when window resizes
  */

  $(window).on('resize.countryswitcher', function () {
    $('.country-switcher-modal').hide();
  });


});
