$(function(){function e(){t($("input[name=all_markers]"))}function t(t){t.each(function(){function a(){return!!(o&&$(o.div_).length>0&&$(o.div_).is(":visible"))}function i(){o=new InfoBox({content:u(f,h,v,y,w,T),closeBoxURL:"",pixelOffset:new google.maps.Size(-100,-200)}),window.ib=o,s&&"function"==typeof s.close&&s.close(),o.open(n.map,r),s=o,p=!1,n.map.panTo(r.getPosition()),setTimeout(function(){var e=$(".infoBox");e.show(),setTimeout(function(){e.show().css({left:"-="+(e.width()/2-100),top:"-="+(e.height()+31-200)}).css("opacity",1),p=!0,a()||setTimeout(i,100)},100)},100)}var r,g,m=$(this),d=m.val().split(", "),f=m.data("name"),h=m.data("saddress"),v=m.data("address"),y=m.data("url"),T=m.data("custom-maps-url"),w=m.data("salon");l.extend(new google.maps.LatLng(d[0],d[1])),setTimeout(function(){function a(){google.maps.event.addListener(n.map,"drag",function(){p&&s&&"function"==typeof s.close&&s.close()}),google.maps.event.addListener(n.map,"bounds_changed",function(){p&&s&&"function"==typeof s.close&&s.close()}),google.maps.event.addListener(n.map,"zoom_changed",function(){c+=1,c==t.length+1&&e(),p&&s&&"function"==typeof s.close&&s.close()})}g=new google.maps.MarkerImage($("#marker-icon-url").val(),null,null,null,new google.maps.Size(19,19)),r=n.addMarker({lat:d[0],lng:d[1],icon:g,title:f,click:function(){i()}}),a(),google.maps.event.addListenerOnce(n.map,"idle",function(){function e(e,t){for(var a=e.mapTypes.get(e.getMapTypeId()).maxZoom||21,i=e.mapTypes.get(e.getMapTypeId()).minZoom||0,o=e.getProjection().fromLatLngToPoint(t.getNorthEast()),n=e.getProjection().fromLatLngToPoint(t.getSouthWest()),s=Math.abs(o.x-n.x),l=Math.abs(o.y-n.y),r=40,p=a;p>=i;--p)if(s*(1<<p)+2*r<$(e.getDiv()).width()&&l*(1<<p)+2*r<$(e.getDiv()).height())return p;return 0}0==c&&(w?setTimeout(function(){i()},100):(n.map.setCenter(l.getCenter()),1==t.length?n.map.setZoom(15):n.map.setZoom(e(n.map,l))))})},0)})}var a=$(window);a.on("resize.sticky",function(){a.width()<=1060?($("#contact-us-request-a-tour").trigger("sticky_kit:detach"),$(".request-a-tour-form-column").css("height","auto")):($(".request-a-tour-form-column").append($("#contact-us-request-a-tour")).height($(".location-page-container").outerHeight()),$("#contact-us-request-a-tour").stick_in_parent())}).trigger("resize.sticky");var i=[{featureType:"administrative",elementType:"all",stylers:[{visibility:"on"},{saturation:-100},{lightness:20}]},{featureType:"road",elementType:"all",stylers:[{visibility:"on"},{saturation:-100},{lightness:40}]},{featureType:"water",elementType:"all",stylers:[{visibility:"on"},{color:"#C1E6F3"}]},{featureType:"water",elementType:"labels",stylers:[{visibility:"off"}]},{featureType:"landscape.man_made",elementType:"all",stylers:[{visibility:"simplified"},{saturation:-60},{lightness:10}]},{featureType:"landscape.natural",elementType:"all",stylers:[{visibility:"simplified"},{saturation:-60},{lightness:60}]},{featureType:"poi",elementType:"all",stylers:[{visibility:"off"},{saturation:-100},{lightness:60}]},{featureType:"transit",elementType:"all",stylers:[{visibility:"off"},{saturation:-100},{lightness:60}]}];if($("#map").length){var o,n=new GMaps({div:"#map",lat:parseFloat($("#lat").val(),10),lng:parseFloat($("#lng").val(),10),zoom:parseInt($("#zoom").val(),10),streetViewControl:!1,draggable:!($("#is_salon").length>0),scrollwheel:!1,disableDefaultUI:$("#is_salon").length>0,mapTypeControlOptions:{mapTypeIds:[]},styles:i}),s=null,l=new google.maps.LatLngBounds,r=$("input[name=marker]"),p=!1,c=0,u=function(e,t,a,i,o,n){return o?n?'<div class="sola-infobox"><h4>'+e+"</h4><p>"+a+'</p><a target="_blank" href="'+n+'">Map it!</a><div class="tail1"></div><div class="tail2"></div></div>':'<div class="sola-infobox"><h4>'+e+"</h4><p>"+a+'</p><a target="_blank" href="http://maps.google.com/maps?daddr='+t+'">Map it!</a><div class="tail1"></div><div class="tail2"></div></div>':'<div class="sola-infobox"><h4>'+e+"</h4><p>"+a+'</p><a href="'+i+'">'+I18n.t("page.search.view_location")+'</a><div class="tail1"></div><div class="tail2"></div></div>'};t(r);var g=$("#map");g.hasClass("fullscreen")&&g.css("height",$(window).height()),$(".view-map a").on("click",function(){return $("body, html").animate({scrollTop:$("#map").position().top}),!1})}var m=$(".salon-map .static-map");m.length&&($(window).on("resize.staticpopover",function(){var e=$(".salon-map .popover"),t=m.height();if(t>=420)var a=30;else if(t>=300&&420>t)var a=25;else var a=20;e.css({marginTop:-(e.height()/2+e.height()/2+a)+"px",marginLeft:-(e.width()/2+1)+"px"}),e.find(".arrow").css({left:e.width()/2-8+"px"})}).trigger("resize.staticpopover"),m.on("load",function(){$(window).trigger("resize.staticpopover")})),$(".rent-a-studio").on("click",function(){$("html, body").animate({scrollTop:$("#rent-a-studio").offset().top},"slow")})});