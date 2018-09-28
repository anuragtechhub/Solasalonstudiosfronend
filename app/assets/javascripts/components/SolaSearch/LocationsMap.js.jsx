var LocationsMap = React.createClass({

	getInitialState: function () {
		return {
			processedMarkers: false,
			map: false,
		}
	},

	componentDidMount: function () {
		var self = this;

	  var map = new GMaps({
	    div: self.refs.map,
	    lat: self.props.lat,
	    lng: self.props.lng,
	    zoom: self.props.zoom,
	    streetViewControl: false,
	    draggable: true,//$('#is_salon').length > 0 ? false : true,
	    scrollwheel: false,//$('#is_salon').length > 0 ? false : true,
	    disableDefaultUI: false,//$('#is_salon').length > 0 ? true : false,
	    mapTypeControlOptions: {
	      mapTypeIds: []
	    },
	  });

	  this.setState({map: map});

		google.maps.event.addListener(map.map, "tilesloaded", function () {
			//console.log('tilesloaded!!!');
			if (!self.state.processedMarkers) {
				//console.log('processMarkers!!!');
				self.processMarkers();
				self.setState({processedMarkers: true});
			}
		});	 

		$(self.refs.map).on('click', '.popup-bubble-content', function (event) {
			console.log('click on marker', $(event.target).html(), event.target.dataset.id);
			self.props.onChangeLocationId(event.target.dataset.id);
		});
	},

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
	  var MAX_ZOOM = 21;
	  var MIN_ZOOM = 0;

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
	  return 0;
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