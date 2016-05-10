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

    $select.find('.option').on('click', function (event) {
      window.location.href = $(event.target).data('value');
      return false;
    });

  });
  
  function adjustiframes() {
    $('.blog-post-article .summary iframe').each(function(){
      var
      $this       = $(this),
      proportion  = $this.data( 'proportion' ),
      w           = $this.attr('width'),
      actual_w    = $this.width();
      
      if ( ! proportion )
      {
          proportion = $this.attr('height') / w;
          $this.data( 'proportion', proportion );
      }
    
      if ( actual_w != w )
      {
          $this.css( 'height', Math.round( actual_w * proportion ) + 'px' );
      }
    });
  };

  $(window).on('load resize refresh', adjustiframes);

  adjustiframes();

});