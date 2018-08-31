var ProfessionalServicesDropdown = React.createClass({

	getInitialState: function () {
		return {
			selectedService: this.props.services && this.props.services.length > 0 ? this.props.services[0] : null
		};
	},



	/**
	* Render functions
	*/

	render: function () {
		var self = this;
		var services = this.props.services.map(function (service) {
			return (
				<li key={service.guid}>
					<a href="#" onClick={self.onSelect.bind(null, service)}>{self.renderService(service)}</a>
				</li>
			);
		});

		return (
			<div className="ProfessionalServicesDropdown">
				<div className="dropdown">
				  <button className="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">
				    {this.state.selectedService ? this.renderService(this.state.selectedService) : null}
				    <span className="fa fa-angle-down"></span>
				  </button>
				  <ul className="dropdown-menu">
				    {services}
				  </ul>
				</div>
			</div>
		);
	},

	renderService: function (service) {
		return (
			<span>
				{service.name} <strong>${this.renderPrice(service.price)}</strong>
			</span>
		);
	},

	renderPrice: function (price) {
		if (price) {
			if (price.charAt(price.length - 1) == '+') {
				return parseInt(price).toFixed(0) + '+';
			} else {
				return parseInt(price).toFixed(0);
			}
		} else {
			return price;
		}
	},



	/**
	* Change handlers	
	*/

	onSelect: function (service, event) {
		event.preventDefault();
		this.setState({selectedService: service});
	},

});