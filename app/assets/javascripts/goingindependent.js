$(function () {

	function scrollToAnchor(aid) {
		var aTag = $("a[name='"+ aid +"']");
		$('html,body').animate({scrollTop: aTag.offset().top},'slow');
	}

	$('a.get-your-free-guide').on('click', function (e) {
		e.preventDefault();
		e.stopPropagation();

		scrollToAnchor('get-your-free-guide');
	});

});