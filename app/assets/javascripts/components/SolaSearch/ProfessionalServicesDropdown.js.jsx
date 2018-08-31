var ProfessionalServicesDropdown = React.createClass({

	render: function () {
		//console.log('ProfessionalServicesDropdown - this.props.services', this.props.services);
		var services = this.props.services.map(function (service) {
			return (
				<li key={service.guid}>
					<a href="#">{service.name} <strong>${service.price}</strong></a>
				</li>
			);
		});

		return (
			<div className="ProfessionalServicesDropdown">
				<div className="dropdown">
				  <button className="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">
				    Haircut <strong>$90</strong>
				    <span className="fa fa-angle-down"></span>
				  </button>
				  <ul className="dropdown-menu">
				    {services}
				  </ul>
				</div>
			</div>
		);
	},

});