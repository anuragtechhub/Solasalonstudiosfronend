var BookingModalReview = React.createClass({

	getInitialState: function () {
		return {
			defaultCoverImageUrl: 'https://s3-us-west-2.amazonaws.com/glossgenius-static-v2/user_avatar.jpg',
			useDefaultCoverImage: false,
		};
	},

	render: function () {
		//console.log('render BookingModalReview', this.state);
		return (
			<div className="BookingModalReview">
				{this.renderHeader()}
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
					<a href={this.props.professional.booking_page_url} target={this.props.professional.booking_page_url} className="Contact">{I18n.t('sola_search.contact')} {this.props.professional.full_name}</a>
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