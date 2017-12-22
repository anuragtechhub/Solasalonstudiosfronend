$(function () {

	/**
	* Animated service heading
	*/
	function animateToNextService() {
		var $services = $('.home-services-animation span');
		var $active = $services.filter('.active');
		var active_index = $services.index($active);

		if (active_index >= $services.length - 1) {
			$active.removeClass('active');
			$services.eq(0).addClass('active');
		} else {
			$active.removeClass('active');
			$services.eq(active_index + 1).addClass('active');
		}
	};

	setInterval(animateToNextService, 2500);

});