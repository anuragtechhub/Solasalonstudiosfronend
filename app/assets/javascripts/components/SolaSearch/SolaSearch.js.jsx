var SolaSearch = React.createClass({

	getInitialState: function () {
		return {
			availabilities: this.props.availabilities || {},
			date: this.props.date ? moment(this.props.date, "YYYY-MM-DD") : moment(),
			error: null,
			fingerprint: this.props.fingerprint,
			gloss_genius_api_key: this.props.gloss_genius_api_key,
			gloss_genius_api_url: this.props.gloss_genius_api_url,
			lat: this.props.lat,
			lng: this.props.lng,
			location: this.props.location,
			locations: this.props.locations || [],
			professionals: this.props.professionals || [],
			query: this.props.query,
			stylist_search_results_path: this.props.stylist_search_results_path,
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
					professionals={this.state.professionals} 
					query={this.state.query} 
					stylist_search_results_path={this.state.stylist_search_results_path} 
				/>
				<LocationsMap lat={this.state.lat} lng={this.state.lng} locations={this.state.locations} zoom={this.state.zoom} />
			</div>
		);
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