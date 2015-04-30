$(function () {

  var modal = $('.send-a-message-modal').modal();

  // open send a message modal
  $('.send-a-message-button').on('click', function () {
    modal.data('modal').open();
    return false;
  })

  // form handler
  $('#send-a-message').on('submit', function () {
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
  $('#send-a-message').tooltipster({theme: 'tooltipster-noir', timer: 3000, trigger: 'foo'});

});