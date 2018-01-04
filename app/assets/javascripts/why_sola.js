$(function () {
	
	$('.floating-find-a-studio a').on('click', function () {
		$('body, html').animate({
			scrollTop: $('.search-for-a-salon').position().top
		});

		return false;
	});	

});