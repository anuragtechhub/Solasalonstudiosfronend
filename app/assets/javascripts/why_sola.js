$(function () {

	$('a[href=#search-for-a-salon]').on('click', function () {
		$('body, html').animate({
			scrollTop: $('.search-for-a-salon').position().top
		});

		return false;
	});

  window.isButtonVisible = true;

  function setButtonVisability () {
    if (document.documentElement.clientWidth > 550) {
      const element = $('.paralax-hidable-desktop');
      const threshold = $('#why_sola')[0].offsetTop;

      if (document.documentElement.scrollTop > threshold && window.isButtonVisible) {
        element.addClass('invisible');
        window.isButtonVisible = false;
      } else if (document.documentElement.scrollTop < threshold && !window.isButtonVisible) {
        element.removeClass('invisible');
        window.isButtonVisible = true;
      }
    }
  }

  $(window).on('DOMContentLoaded load scroll', setButtonVisability);
});
