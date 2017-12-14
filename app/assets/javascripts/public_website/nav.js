$(function () {

	var $mobileNavWrapper = $('.mobile-nav-wrapper');
	var $mobileNavMenu = $mobileNavWrapper.find('.mobile-nav');



  /**
  * Mobile top nav hamburger menu
  */

  $('#mobile-top-nav-button').on('click touchstart', function (e) {
    e.stopPropagation();
    e.preventDefault();

    if ($mobileNavWrapper.is(':visible')) {
      $mobileNavWrapper.fadeOut('fast');
      $mobileNavMenu.removeClass('open');
      $('body').off('touchmove.mobileNav').removeClass('stop-scrolling');
    } else {
      $mobileNavWrapper.fadeIn('fast');
      $mobileNavMenu.addClass('open');

      // prevent page scroll
      $('body').on('touchmove.mobileNav', function (e) {
      	e.preventDefault();
      }).addClass('stop-scrolling');
    }
  });



  /**
  * Close sliding mobile nav menus
  */

  $mobileNavMenu.find('.close-x-black').on('click', function () {
    //if ($mobileNavWrapper.is(':visible')) {
      $mobileNavMenu.removeClass('open');
      setTimeout(function () {
      	$mobileNavWrapper.fadeOut('fast', function () {
          // reset submenus
          $mobileNavMenu.find('.sliding-submenu').removeClass('open');
          $mobileNavMenu.find('.mobile-nav-top-menu').addClass('open');
        });
      }, 150);
      $('body').off('touchmove.mobileNav').removeClass('stop-scrolling');
    //}
  });



  /**
  * Sliding mobile submenus
  */
  $mobileNavMenu.find('li > ul').each(function () {
    var $child_ul = $(this);
    var $parent_li = $child_ul.parent('li');

    $child_ul.addClass('sliding-submenu');
    $mobileNavMenu.append($child_ul);

    // clicking parent to open child
    $parent_li.find('> a').on('click', function () {
      var $this = $(this);
      var $parent = $this.parents('ul');
      var $submenu = $mobileNavMenu.find('.sliding-submenu[data-submenu="' + $this.data('submenu') + '"]');

      console.log('you clicked????', $parent, $submenu);

      if ($parent.hasClass('open')) {
        console.log('adding open to submenu')
        $parent.removeClass('open');
        $submenu.addClass('open');
      } else {
        console.log('removing open from submenu')
        $parent.addClass('open');
        $submenu.removeClass('open');
      }
      
      return false;
    });

    // clicking child to open parent
    $mobileNavMenu.find('.sliding-submenu a[data-menu]').each(function () {
      var $submenu_a = $(this);

      $submenu_a.on('click', function () {
        $('ul[data-menu="' + $submenu_a.data('menu') + '"').addClass('open');
        $submenu_a.parents('[data-submenu]').removeClass('open');
        return false;
      })
    })
  });


});