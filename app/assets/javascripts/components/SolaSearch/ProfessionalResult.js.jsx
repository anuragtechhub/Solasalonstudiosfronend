var ProfessionalResult = React.createClass({

	getInitialState: function () {
		return {
			defaultCoverImageUrl: 'https://s3-us-west-2.amazonaws.com/glossgenius-static-v2/user_avatar.jpg',
			useDefaultCoverImage: false
		};
	},

	render: function () {
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
				</div>
			</div>
		);
	},

	onCoverImageError: function () {
		this.setState({useDefaultCoverImage: true});
	},

});