$(function () {
  
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