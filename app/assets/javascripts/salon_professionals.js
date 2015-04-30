$(function () {

  var modal = $('.send-a-message-modal').modal();

  // open send a message modal
  $('.send-a-message-button').on('click', function () {
    modal.data('modal').open();
    return false;
  })

});