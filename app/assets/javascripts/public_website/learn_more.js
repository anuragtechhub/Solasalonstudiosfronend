$(function () {

	$('.hero-carousel .learn-more-button').on('click', function () {
		var $container = $(this).parents('.hero-carousel').siblings('.container').first(); //next();

		//console.log('container length', $container.length);

		$('body, html').animate({
			scrollTop: $container.position().top
		});

		return false;
	});

});