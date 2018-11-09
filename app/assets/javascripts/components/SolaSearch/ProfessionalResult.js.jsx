var ProfessionalResult = React.createClass({

	getInitialState: function () {
		return {
			defaultCoverImageUrl: 'https://s3-us-west-2.amazonaws.com/glossgenius-static-v2/user_avatar.jpg',
			selectedService: this.props.selectedService || this.props.professional.matched_services[0],
			useDefaultCoverImage: false
		};
	},

	componentWillReceiveProps: function (nextProps) {
		if (!this.state.selectedService) {
			this.setState({selectedService: nextProps.professional.matched_services[0]});
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
						availabilities={this.props.availabilities} 
						booking_page_url={this.props.booking_page_url} 
						full_name={this.props.full_name} 
						onShowBookingModal={this.props.onShowBookingModal} 
						professional={this.props.professional} 
					/>
				</div>
			</div>
		);
	},


	/**
	* Change handlers
	*/

	onChangeSelectedService: function (service) {
		console.log('selectedService', service);
		this.setState({selectedService: service});
	},

	onCoverImageError: function () {
		this.setState({useDefaultCoverImage: true});
	},

});