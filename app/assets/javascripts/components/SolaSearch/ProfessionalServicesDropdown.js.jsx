var ProfessionalServicesDropdown = React.createClass({

	getInitialState: function () {
		return {
			dropdownWidth: 0,
			maxWidth: 0,
			//selectedService: this.props.services && this.props.services.length > 0 ? this.props.services[0] : null
		};
	},

	componentDidUpdate: function () {
		var self = this;
		this.calculateDropdownSizes();

		$(this.refs.dropdown).on('shown.bs.dropdown', function () {
			$(self.refs.dropdown).find('.dropdown-menu.show').css(self.calculateOffset());
		});
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
			<div className="ProfessionalServicesDropdown" ref="dropdown">
				<div className="dropdown">
				  <button className="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">
				    {this.props.selectedService ? this.renderService(this.props.selectedService) : null}
				    <span className="fa fa-angle-down"></span>
				  </button>
				  <ul className="dropdown-menu" ref="dropdownMenu" style={{width: this.state.maxWidth}}>
				    {services}
				  </ul>
				</div>
			</div>
		);
	},

	renderService: function (service) {
		return (
			<span className="service-item">
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
		this.props.onChange(service);
	},



	/**
	* Helper functions
	*/

	calculateDropdownSizes: function () {
		var $dropdown = $(this.refs.dropdown);
		var $dropdownMenu = $(this.refs.dropdownMenu);
		var max_width = 0;

		$dropdownMenu.find('.service-item').each(function () {
			var width = $(this).textWidth();
			//console.log('width', width);
			if (max_width < width.outerWidth) {
				max_width = width.outerWidth + 20;
			}
		});

		var dropdownWidth = $dropdown.outerWidth();
		if (dropdownWidth >= max_width) {
			max_width = dropdownWidth;
		}

		//console.log('width', dropdownWidth, max_width)
		
		this.setState({dropdownWidth: dropdownWidth, maxWidth: max_width});
	},

	calculateOffset: function () {
		if (this.state.dropdownWidth >= this.state.maxWidth) {
			//console.log('returning 0')
			return {right: 0};
		} else {
			//console.log('returning', this.state.maxWidth - (this.state.dropdownWidth));
			return {right: -(this.state.maxWidth - this.state.dropdownWidth - 8)};
		}
	}

});