$(function () {

  // tabs
  $('a.mysola-tab').on('click.tabs', function (e) {
    var $this = $(this);

    // link active
    $('a.mysola-tab').removeClass('active');
    $this.addClass('active');

    // tab visibility
    $('.mysola-tab-content').hide();
    $('.mysola-tab-content[data-tab=' + $this.data('tab') + ']').show();

    e.preventDefault();
  });

  // magic_line
  var $main_nav = $(".mysola-tabs-container");
  $main_nav.append("<div id='magic-line'></div>");
  var $magic_line = $("#magic-line");

  // resize handler
  $(window).on('resize.magicline', function () {
    $magic_line.css('left', $main_nav.find('a.active').offset().left);
    $magic_line.width($main_nav.find('a.active').outerWidth());
  }).trigger('resize.magicline');

  // click handler
  $('a.mysola-tab').on('click.magicline', function (e) {
    // update magic_line width
    $magic_line.stop().animate({
      left: $main_nav.find('a.active').offset().left,
      width: $main_nav.find('a.active').outerWidth()
    });

    e.preventDefault();
  });

});