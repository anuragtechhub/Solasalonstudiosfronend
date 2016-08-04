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

    $select.find('.option').on('click', function (event) {
      var state = $(event.target).data('value');
      $('#contact-us-info-disabled').show();
      $('.contact-us-info').hide();
      
      $('.sola-select .options').hide();
      $(window).off('click.solaselect');
      $select.find('.option-placeholder h3').html(state);

      $('.select-a-location').hide();
      $('#state_select_' + state.replace(/ /g, '_')).show();
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

    $select.find('.option').on('click', function (event) {
      var locationId = $(event.target).data('value');
      var locationName = $(event.target).html();

      $('.sola-select .options').hide();
      $(window).off('click.solaselect');
      $select.find('.option-placeholder h3').html(locationName);
      $('#contact_us_location_id').val(locationId);

      if ($(event.target).data('phone')) {
        $('#contact-us-number').html($(event.target).data('phone')).attr('href', 'tel:' + $(event.target).data('phone'));
      } else {
        $('#contact-us-number').html('(303) 377-7652').attr('href', 'tel:(303) 377-7652');
      }

      $('#contact-us-info-disabled').hide();
      $('.contact-us-info').show();
      return false;
    });

  }).disableSelection();

  // form handler
  $('form.contact-us-form').on('submit', function () {
    var $form = $(this);

    $.ajax({
      method: 'POST',
      url: $form.attr('action'),
      data: $form.serialize()
    }).done(function(data) {
      if (data && data.success) {
        $form.find('input, textarea').val('').blur().end().tooltipster('content', data.success).tooltipster('show');
      } else {
        $form.tooltipster('content', data.error).tooltipster('show');
      }
    });

    return false;
  });
  $('form.contact-us-form').tooltipster({theme: 'tooltipster-noir', timer: 3000, trigger: 'foo'});

});