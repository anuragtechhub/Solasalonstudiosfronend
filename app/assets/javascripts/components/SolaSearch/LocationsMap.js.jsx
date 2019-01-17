var LocationsMap = React.createClass({

	getInitialState: function () {
		return {
			processedMarkers: false,
			map: false,
		}
	},

	componentDidMount: function () {
		this.initMap();
	},

	componentDidUpdate: function (prevProps, prevState) {
		if (this.state.map && prevProps.display != this.props.display || prevProps.mode != this.props.mode) {
			$(this.refs.map).css({width: '100%', height: '100%'});
		}
	},

	initMap: function () {
		var self = this;

		var lat = self.props.locations.length == 0 ? 39.8097343 : self.props.lat;
		var lng = self.props.locations.length == 0 ? -98.5556199 : self.props.lng;
		var zoom = self.props.locations.length == 0 ? 4 : self.props.zoom;

	  var map = new GMaps({
	    div: self.refs.map,
	    lat: lat,
	    lng: lng,
	    zoom: zoom,
	    streetViewControl: false,
	    draggable: true,//$('#is_salon').length > 0 ? false : true,
	    scrollwheel: false,//$('#is_salon').length > 0 ? false : true,
	    disableDefaultUI: false,//$('#is_salon').length > 0 ? true : false,
	    mapTypeControlOptions: {
	      mapTypeIds: []
	    },
	  });

	  this.setState({map: map});

	  if (self.props.locations.length) {
			google.maps.event.addListener(map.map, "tilesloaded", function () {
				//console.log('tilesloaded!!!');
				if (!self.state.processedMarkers) {
					//console.log('processMarkers!!!');
					self.processMarkers();
					self.setState({processedMarkers: true});
				}
			});	 

			$(self.refs.map).on('click', '.popup-bubble-content', function (event) {
				//console.log('click on marker', $(event.target).html(), event.target.dataset.id);
				self.props.onChangeLocationId(event.target.dataset.id);
			});
	  }
	},



	/**
	* Render functions
	*/

	render: function () {
		return (
			<div className="LocationsMap">
				<div ref="map" className="map"></div>
			</div>
		);
	},



	/**
	* Helper functions
	*/

	getZoomByBounds: function (map, bounds) {
	  var MAX_ZOOM = 16;
	  var MIN_ZOOM = 3;

	  // console.log('map', map);
	  // console.log('map.getProjection()', map.getProjection());

	  var ne = map.getProjection().fromLatLngToPoint(bounds.getNorthEast());
	  var sw = map.getProjection().fromLatLngToPoint(bounds.getSouthWest()); 

	  var worldCoordWidth = Math.abs(ne.x - sw.x);
	  var worldCoordHeight = Math.abs(ne.y - sw.y);

	  //Fit padding in pixels 
	  var FIT_PAD = 40;

	  for( var zoom = MAX_ZOOM; zoom >= MIN_ZOOM; --zoom ){ 
	      if( worldCoordWidth*(1<<zoom)+2*FIT_PAD < $(map.getDiv()).width() && 
	          worldCoordHeight*(1<<zoom)+2*FIT_PAD < $(map.getDiv()).height() )
	          return zoom;
	  }

	  return MIN_ZOOM;
	},

	processMarkers: function () {
		if (!this.state.map) {
			//console.log('no map - returning')
			return;
		}

		//console.log('processMarkers!');
	  var latlngbounds = new google.maps.LatLngBounds();
	  //var zoomCount = 0;

		for (var i = 0, ilen = this.props.locations.length; i < ilen; i++) {
			var location = this.props.locations[i];
			//console.log('location', location);
			latlngbounds.extend(new google.maps.LatLng(location.latitude, location.longitude));
		  var contentDiv = document.createElement('div');
		  contentDiv.dataset.id = location.id;
		  var contentText = document.createTextNode(location.name);
		  contentDiv.append(contentText);
		  popup = new Popup(new google.maps.LatLng(location.latitude, location.longitude), contentDiv);
		  popup.setMap(this.state.map.map);

			// var marker = this.state.map.addMarker({
   //      lat: location.latitude,
   //      lng: location.longitude,
   //      //icon: markerIcon,
   //      title: location.name,
   //      click: function (e) {
   //        console.log('click marker!');
   //      }
   //    });
		}

		this.state.map.map.setCenter(latlngbounds.getCenter());
		this.state.map.map.setZoom(this.getZoomByBounds(this.state.map.map, latlngbounds));
	},



});