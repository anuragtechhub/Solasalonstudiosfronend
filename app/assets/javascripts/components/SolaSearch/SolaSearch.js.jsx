var SolaSearch = React.createClass({

	getInitialState: function () {
		return {
			availabilities: this.props.availabilities || {},
			bookingModalVisible: false,
			date: this.props.date ? moment(this.props.date, "YYYY-MM-DD") : moment(),
			error: null,
			fingerprint: this.props.fingerprint,
			gloss_genius_api_key: this.props.gloss_genius_api_key,
			gloss_genius_api_url: this.props.gloss_genius_api_url,
			lat: this.props.lat,
			lng: this.props.lng,
			location: this.props.location,
			location_id: this.props.location_id,
			location_name: this.props.location_name,
			locations: this.props.locations || [],
			professional: this.props.professional,
			professionals: this.props.professionals || [],
			query: this.props.query,
			services: [],
			stylist_search_results_path: this.props.stylist_search_results_path,
			time: this.props.time,
			zoom: this.props.zoom,
		};
	},

	componentDidMount: function () {
		this.getAvailabilities(this.getServicesGuids());
	},



	/**
	* Render functions
	*/

	render: function () {
		//console.log('render SolaSearch professionals', this.state.professionals);
		
		return (
			<div className="SolaSearch">
				<ProfessionalResults 
					availabilities={this.state.availabilities} 
					date={this.state.date} 
					lat={this.state.lat}
					lng={this.state.lng}
					location={this.state.location}
					location_id={this.state.location_id}
					location_name={this.state.location_name}
					onShowBookingModal={this.onShowBookingModal}
					professionals={this.state.professionals} 
					query={this.state.query} 
					stylist_search_results_path={this.state.stylist_search_results_path} 
				/>
				<LocationsMap lat={this.state.lat} lng={this.state.lng} locations={this.state.locations} onChangeLocationId={this.onChangeLocationId} zoom={this.state.zoom} />
				<BookingModal 
					onHideBookingModal={this.onHideBookingModal}
					professional={this.state.professional} 
					services={this.state.services}
					time={this.state.time} 
					visible={this.state.bookingModalVisible} 
				/>
			</div>
		);
	},



	/**
	* Change handlers
	*/

	onChangeLocationId: function (location_id) {
		this.setState({location_id: location_id});
	},

	onHideBookingModal: function () {
		this.setState({bookingModalVisible: false, professional: null, time: null, services: []});
	},

	onShowBookingModal: function (professional, time, event) {
		if (event && typeof event.preventDefault == 'function') {
			event.preventDefault();
		}

		//console.log('onShowBookingModal', professional, time);
		this.setState({bookingModalVisible: true, professional: professional, time: time, services: [professional.matched_services[0]]});
	},



	/**
	* Helper functions
	*/

	getAvailabilities: function (services_guids) {
		var self = this;
		
		//console.log('services_guids', JSON.stringify(services_guids));

		$.ajax({
			data: {
				date: this.state.date.format("YYYY-MM-DD"),
				services_guids: services_guids
			},
	    headers: {
	    	"api_key": this.props.gloss_genius_api_key,
	    	"device_id": this.props.fingerprint,
	    },
			method: 'POST',
	    url: this.props.gloss_genius_api_url + 'availabilities',
		}).done(function (response) {
			//console.log('getAvailabilities response', response);
			self.setState({availabilities: JSON.parse(response)});
		}); 
	},

	getServicesGuids: function () {
		var guids = {};

		for (var i = 0, ilen = this.state.professionals.length; i < ilen; i++) {
			guids[this.state.professionals[i].guid] = [];
			
			for (var j = 0, jlen = this.state.professionals[i].matched_services.length; j < jlen; j++) {
				guids[this.state.professionals[i].guid].push(this.state.professionals[i].matched_services[j].guid);
			}
		}

		return guids;
	},

});