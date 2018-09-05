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
});