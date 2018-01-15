$(function () {
	
	$('a[href=#search-for-a-salon]').on('click', function () {
		$('body, html').animate({
			scrollTop: $('.search-for-a-salon').position().top
		});

		return false;
	});	

});