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
        setTimeout(function () {
          modal.data('modal').fadeOut();
        }, 3300);
      } else {
        $form.tooltipster('content', data.error).tooltipster('show');
      }
    });

    return false;
  });
  $('#send-a-message').tooltipster({theme: 'tooltipster-noir', timer: 3000, trigger: 'foo'});

  // $.fn.textWidth = function(){
  //   var html_org = $(this).html();
  //   var html_calc = '<span>' + html_org + '</span>';
  //   $(this).html(html_calc);
  //   var width = $(this).find('span:first').width();
  //   $(this).html(html_org);
  //   return width;
  // }

  // // size name and business name line
  // var $name = $('.salon_professional_name');
  // var $biz = $('.salon_professional_business_name');
  
  // if ($name.textWidth() > $biz.textWidth()) {
  //   $biz.width($name.textWidth());
  // }

});