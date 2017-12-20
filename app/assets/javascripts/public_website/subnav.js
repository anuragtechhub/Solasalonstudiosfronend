$(function () {
	
  /**
  * 'oys' (Own Your Salon and About Us) subnav menus
  */
  var showOysNav = function (nav) {
    if ($(window).width() > 1000) {
      // desktop
      var $headerContainer = $('#header .container');
      $('.oys-nav').not('[data-nav="' + nav + '"]').hide();
      $('.oys-nav[data-nav="' + nav + '"]').css({left: $headerContainer.offset().left, top: $headerContainer.outerHeight() + $('#top-header').outerHeight() - 2}).width($headerContainer.outerWidth()).show();
    }
  };

  $('#header .own_your_salon, #header .about_us').on('mouseenter', function () {
    //showOysNav();
  }).hoverIntent({
    over: function (e) {
      //console.log('over! show it')
      var $this = $(e.target);
      showOysNav($this.data('nav'));
    }, 
    out: function (e) {
      //console.log('out! hide it');
      var $this = $(e.target);

      var $oysNav = $('.oys-nav[data-nav="' + $this.data('nav') + '"]');

      if ($oysNav.hasClass('over')) {
        // shhh...
      } else {
        $oysNav.hide();
      }
    },
    timeout: 500
  });

  $('.oys-nav').on('mouseenter', function (e) {
    //console.log('mouseenter show!')
    var $this = $(e.target);
    $('.oys-nav[data-nav="' + $this.data('nav') + '"]').addClass('over').show();
  });  

  $('.oys-nav').on('mouseleave', function (e) {
    //console.log('mouseleave hide!');
    var $this = $(e.target);
    $('.oys-nav[data-nav="' + $this.data('nav') + '"]').removeClass('over').hide();
  }); 



  /**
  * In-page subnav (scroll to right section if needed)
  */
  $('.page-nav').each(function () {
    var $pagenav = $(this);
    var pagenav_width = $pagenav.outerWidth();
    
    // calculate widths
    var items_width = 0;
    var width_before_active = 0;
    var active_index = -1;
    
    $pagenav.find('li').each(function (idx) {
      var $li = $(this);
      var li_width = $li.outerWidth(true);

      items_width = items_width + li_width;

      if (active_index == -1) {
        width_before_active = width_before_active + li_width;
      }

      if ($li.hasClass('active')) {
        active_index = idx;
      };
    });

    //console.log('pagenav_width', pagenav_width, items_width, active_index, width_before_active);

    if (width_before_active > pagenav_width) {
      $pagenav.scrollLeft(pagenav_width);
    }
  });

});