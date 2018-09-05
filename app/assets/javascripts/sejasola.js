//= require slick

$(document).ready(function(e){
	
   $('.slider-main').slick({
        dots: true,
        infinite: false,
        speed: 300,
        slidesToShow: 3,
        slidesToScroll: 2,
        autoplay: true,
        autoplaySpeed: 2000,
        arrows:false,
        responsive: [
       {
       breakpoint: 991,
       settings: {
       slidesToShow: 2,
       slidesToScroll: 1
      }
      },
      {
       breakpoint: 575,
      settings: {
       slidesToShow: 1,
       slidesToScroll: 1
       }
       }
       
       ]
        });

  $('#form').on('submit', function (e) {
  	e.stopPropagation();
  	e.preventDefault();
  	
  	var $submit = $('#submit');
  	var nome = $('#nome').val();
  	var email = $('#email').val();
  	var telefone = $('#telefone').val();

  	if (nome && nome != '' && email && email != '' && telefone && telefone != '') {
			$.ajax({
			  data: {
			  	nome: nome,
			  	email: email,
			  	telefone: telefone,
			  },
			  method: 'post'
			}).done(function() {
			  console.log('done!')
			});

  		$submit.popover();
  		$submit.popover('dispose');
  		$submit.popover({content: '<i style="color:green;font-style:normal;">Obrigado!</i>', html: true, placement: 'top'}).popover('show');
  		setTimeout(function () {
  			$submit.popover('dispose');
  		}, 5000);
  		
  		$('#nome').val('');
  		$('#email').val('');
  		$('#telefone').val('');
  	} else {
  		$submit.popover();
  		$submit.popover('dispose')
  		$submit.popover({content: '<i style="color:red;font-style:normal;">Preencha todos os campos por favor.</i>', html: true, placement: 'top'}).popover('show');
  		setTimeout(function () {
  			$submit.popover('dispose');
  		}, 5000);
  	}
  });
});