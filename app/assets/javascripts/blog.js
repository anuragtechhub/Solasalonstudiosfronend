$(function () {

  // blog category select
  $('.sola-select').each(function () {
    var $select = $(this);
    var $placeholder = $select.find('.option-placeholder');
    var $arrow = $select.find('.arrow');
    var $options = $select.find('.options');

    $select.find('.option-placeholder, .arrow').on('click', function () {
      if ($options.is(':visible')) {
        $options.hide();
        $(window).off('click.solaselect');
      } else {
        $options.show();
        $(window).on('click.solaselect', function () {
          $options.hide();
        });
      }
      return false;
    });

    $select.find('.option').on('click', function () {
      window.location.href = $(event.target).data('value');
      return false;
    });

  });
  
})