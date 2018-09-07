var ProfessionalResult = React.createClass({

	getInitialState: function () {
		return {
			defaultCoverImageUrl: 'https://s3-us-west-2.amazonaws.com/glossgenius-static-v2/user_avatar.jpg',
			useDefaultCoverImage: false
		};
	},

	render: function () {
		//console.log('ProfessionalResult availabilities', this.props.availabilities);

		return (
			<div className="ProfessionalResult">
				<ProfessionalServicesDropdown booking_page_url={this.props.booking_page_url} services={this.props.all_services} />
				<div className="ProfessionalCoverImage">
					<img src={this.state.useDefaultCoverImage ? this.state.defaultCoverImageUrl : this.props.cover_image} alt={this.props.full_name} onError={this.onCoverImageError} />
					<span className="ProfessionalCoverImageName">{this.props.full_name}</span>
				</div>
				<div className="ProfessionalResultDetails">
					<div className="ProfessionalName">{this.props.full_name}</div>
					<div className="ProfessionalAddress">{this.props.business_address}</div>
					{this.renderAvailabilities()}
				</div>
			</div>
		);
	},

	renderAvailabilities: function () {
		var self = this;
		
		if (this.props.availabilities && this.props.availabilities.length > 0) {
			var availabilities = this.props.availabilities.map(function (availability) {
				var times = availability.times.map(function (time) {
					return (
						<a href='#' key={time.start} className="availability-button">{moment(time.start).format('h:mma')}</a>
					);
				});
				return (
					<div className="availability-date" key={availability.date}>
						<div className="date">{moment(availability.date).format('ddd DD/YY')}</div>
						<div className="availabilities">
							{times}
						</div>
					</div>
				);
			});
			return (
				<div className="ProfessionalAvailabilities">
					<div className="ProfessionalAvailabilitiesWrapper">
						{availabilities}
					</div>
				</div>
			);
		} else {
			return (
				<div className="ProfessionalAvailabilities">
					<a href={this.props.booking_page_url} className="availability-button check-availability">{I18n.t('sola_search.check_availability')}</a>
				</div>
			);
		}
	},

	onCoverImageError: function () {
		this.setState({useDefaultCoverImage: true});
	},

});