$(function () {
	
	$('.in-the-news-article').on('click', function (e) {
		window.location.href = $(this).data('href');
		return false;
	});

	$('.in-the-news-article .social a').on('click', function (e) {
		e.stopPropagation();
	});

});