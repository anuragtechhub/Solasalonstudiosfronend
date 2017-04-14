$(function () {

  // tabs
  $('a.mysola-tab').on('click', function () {
    var $this = $(this);

    // link active
    $('a.mysola-tab').removeClass('active');
    $this.addClass('active');

    // tab visibility
    $('.mysola-tab-content').hide();
    $('.mysola-tab-content[data-tab=' + $this.data('tab') + ']').show();

    return false;
  });

});