$(function () {
	
	$('.search-for-a-salon form').on('submit', function () {
		var $this = $(this);
		var query = $this.find('input[name=query]').val();
		console.log('you submitted?', query);
		return false;
	});

});