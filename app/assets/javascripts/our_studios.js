$(function () {
	
	$('.grid-item').on('mouseenter', function () {
		var $this = $(this);

		$this.find('.back').addClass('active');
	});

	$('.grid-item').on('mouseleave', function () {
		var $this = $(this);

		$this.find('.back').removeClass('active');
	});

});