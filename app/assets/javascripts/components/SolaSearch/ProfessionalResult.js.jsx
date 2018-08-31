var ProfessionalResult = React.createClass({

	render: function () {
		return (
			<div className="ProfessionalResult">
				<ProfessionalServicesDropdown services={this.props.all_services} />
				<div className="ProfessionalCoverImage"><img src={this.props.cover_image} alt={this.props.full_name} /></div>
				<div className="ProfessionalResultDetails">
					<div className="ProfessionalName">{this.props.full_name}</div>
					<div className="ProfessionalAddress">{this.props.business_address}</div>
				</div>
			</div>
		);
	},

});