var BookingModalReview = React.createClass({

	getInitialState: function () {
		return {
			defaultCoverImageUrl: 'https://s3-us-west-2.amazonaws.com/glossgenius-static-v2/user_avatar.jpg',
			useDefaultCoverImage: false,
		};
	},

	render: function () {
		//console.log('render BookingModalReview', this.props);
		return (
			<div className="BookingModalReview">
				{this.renderHeader()}
				{this.renderBody()}
			</div>
		);
	},

	renderBody: function () {
		return (
			<div className="Body">
				<BookingModalDateRow {...this.props} {...this.state} />
				<BookingModalTimeRow {...this.props} {...this.state} />
				<BookingModalServicesRow {...this.props} {...this.state} />
			</div>
		);
	},

	renderHeader: function () {
		return (
			<div className="Header">
				<div className="ProfessionalCoverImage">
					<img src={this.state.useDefaultCoverImage ? this.state.defaultCoverImageUrl : this.props.professional.cover_image} alt={this.props.professional.full_name} onError={this.onCoverImageError} />
					<div className="Gradient"></div>
				</div>
				<div className="ProfessionalInfo">
					<div className="ProfessionalName">{this.props.professional.full_name}</div>
					<div className="ProfessionalAddress">{this.props.professional.business_address}</div>
					<a href={'http://' + this.props.professional.booking_page_url} target={this.props.professional.booking_page_url} className="Contact">{I18n.t('sola_search.contact')}&nbsp;{this.props.professional.full_name}</a>
				</div>
			</div>
		);
	},



	/**
	* Change handlers
	*/

	onCoverImageError: function () {
		this.setState({useDefaultCoverImage: true});
	},

});