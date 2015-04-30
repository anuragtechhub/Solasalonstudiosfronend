$(function () {

  // sola state select
  $('.select-a-state').each(function () {
    var $select = $(this);
    var $placeholder = $select.find('.option-placeholder');
    var $arrow = $select.find('.arrow');
    var $options = $select.find('.options');

    $select.find('.option-placeholder, .arrow').on('click', function () {
      $('.sola-select .options').not($options).hide();

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
      var state = $(event.target).data('value');
      console.log('state', state);
      
      $('.sola-select .options').hide();
      $(window).off('click.solaselect');
      $select.find('.option-placeholder h3').html(state);

      $('.select-a-location').hide();
      $('#state_select_' + state).show();
      return false;
    });

  }).disableSelection();

  // sola location select
  $('.select-a-location').each(function () {
    var $select = $(this);
    var $placeholder = $select.find('.option-placeholder');
    var $arrow = $select.find('.arrow');
    var $options = $select.find('.options');

    $select.find('.option-placeholder, .arrow').on('click', function () {
      $('.sola-select .options').not($options).hide();

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
      var locationId = $(event.target).data('value');
      var locationName = $(event.target).html();

      $('.sola-select .options').hide();
      $(window).off('click.solaselect');
      $select.find('.option-placeholder h3').html(locationName);

      $('.contact-us-info').hide();
      $('#contact_us_' + locationId).show();
      return false;
    });

  }).disableSelection();

});