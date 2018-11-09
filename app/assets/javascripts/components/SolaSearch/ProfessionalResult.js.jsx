var ProfessionalResult = React.createClass({

	getInitialState: function () {
		return {
			availabilities: this.props.availabilities,
			defaultCoverImageUrl: 'https://s3-us-west-2.amazonaws.com/glossgenius-static-v2/user_avatar.jpg',
			loading: false,
			selectedService: this.props.selectedService || this.props.professional.matched_services[0],
			useDefaultCoverImage: false
		};
	},

	componentWillReceiveProps: function (nextProps) {
		if (!this.state.selectedService) {
			this.setState({selectedService: nextProps.professional.matched_services[0]});
		}
		if ((!this.state.availabilities || this.state.availabilities.length == 0) && nextProps.availabilities) {
			this.setState({availabilities: nextProps.availabilities});
		}
	},



	/**
	* Render functions
	*/

	render: function () {
		//console.log('ProfessionalResult availabilities', this.props.availabilities);

		return (
			<div className="ProfessionalResult">
				{/*<ProfessionalServicesDropdown booking_page_url={this.props.booking_page_url} services={this.props.all_services} />*/}
				<div className="ProfessionalCoverImage">
					<img src={this.state.useDefaultCoverImage ? this.state.defaultCoverImageUrl : this.props.cover_image} alt={this.props.full_name} onError={this.onCoverImageError} />
					<span className="ProfessionalCoverImageName">{this.props.full_name}</span>
					<div className="Gradient"></div>
				</div>
				
				<div className="ProfessionalResultDetails">
					<div className="ProfessionalName">{this.props.full_name}</div>
					<div className="ProfessionalAddress">{this.props.business_address}</div>
					<ProfessionalServicesDropdown
						services={this.props.professional.matched_services}
						selectedService={this.state.selectedService}
						onChange={this.onChangeSelectedService}
					/>
					<ProfessionalAvailabilities 
						availabilities={this.state.availabilities} 
						booking_page_url={this.props.booking_page_url} 
						full_name={this.props.full_name} 
						onShowBookingModal={this.props.onShowBookingModal} 
						professional={this.props.professional} 
						selectedService={this.state.selectedService}
					/>
				</div>
				{this.state.loading ? <div className="loading"><div className="spinner"></div></div> : null}
			</div>
		);
	},



	/**
	* Change handlers
	*/

	onChangeSelectedService: function (service) {
		var self = this;
		//console.log('selectedService', service);
		this.setState({loading: true, selectedService: service}, function () {
			self.getAvailabilities();
		});
	},

	onCoverImageError: function () {
		this.setState({useDefaultCoverImage: true});
	},



	/**
	* Helper functions
	*/

	getAvailabilities: function () {
		var self = this;
		
		var services_guids = {};
		services_guids[this.props.professional.guid] = this.state.selectedService.guid;
		//console.log('services_guids', services_guids);

		$.ajax({
			data: {
				date: this.props.date.format("YYYY-MM-DD"),
				services_guids: services_guids
			},
	    headers: {
	    	"api_key": this.props.gloss_genius_api_key,
	    	"device_id": this.props.fingerprint,
	    },
			method: 'POST',
	    url: this.props.gloss_genius_api_url + 'availabilities',
		}).done(function (response) {
			//console.log('getAvailabilities response', JSON.parse(response));
			self.setState({availabilities: JSON.parse(response)[self.props.professional.guid], loading: false});
		}); 
	},

});