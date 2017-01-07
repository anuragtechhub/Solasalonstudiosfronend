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

  // gallery
  $('a[rel=sola5000]').swipebox();

  // partner inquiry
  var $partner_modal = $('.partner-modal').modal();

  // open send a message modal
  $('.partner-button').on('click', function () {
    $partner_modal.data('modal').open();
    return false;
  });

  // form handler
  $('#partner_inquiry').on('submit', function () {
    var $form = $(this);

    $.ajax({
      method: 'POST',
      url: $form.attr('action'),
      data: $form.serialize()
    }).done(function(data) {
      if (data && data.success) {
        $form.find('input, textarea').val('').blur().end().tooltipster('content', data.success).tooltipster('show');
        setTimeout(function () {
          $partner_modal.data('modal').fadeOut();
        }, 3300);
      } else {
        $form.tooltipster('content', data.error).tooltipster('show');
      }
    });

    return false;
  });
  $('#partner_inquiry').tooltipster({theme: 'tooltipster-noir', timer: 3000, trigger: 'foo'});

});
