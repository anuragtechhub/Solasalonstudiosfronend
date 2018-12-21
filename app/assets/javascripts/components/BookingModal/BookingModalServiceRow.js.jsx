var BookingModalServiceRow = React.createClass({

	getInitialState: function () {
		return {
			defaultImageUrl: 'https://s3-us-west-2.amazonaws.com/glossgenius-static-v2/service_placeholder.png',
			useDefaultImage: false
		};
	},



	/**
	* Render functions
	*/
 
	render: function () {
		//console.log('BookingModalService', this.props.service);

		return (
			<div className={"ServiceRow " + (this.props.service.image ? 'HasImage' : null)}>
				{this.renderServiceImage()}
				<div className="ServiceDetails">
					<div className="ServiceName">{this.props.service.name}</div>
					<div className="ServiceCostAndDuration">
						<span className="ServiceCost">{this.calculateTotalCost()}</span> 
						<span className="Separator">&nbsp;</span> 
						<span className="ServiceDuration">{this.props.service.duration} {I18n.t('sola_search.min')}</span>
					</div>
				</div>
				{this.renderToggleSwitch()}
			</div>
		);
	},

	renderToggleSwitch: function () {
		if (this.props.toggleSwitch) {
			return (
				<div className={"toggle-switch-button " + (this.props.serviceSelected ? "active" : "")} onClick={this.onToggleService.bind(this, this.props.service)}>
					<span className={"fa " + (this.props.serviceSelected ? "fa-check" : "fa-plus")}></span>
				</div>
			);
		}
	},

	renderServiceImage: function () {
		if (this.props.service && this.props.service.image) {
			return (
				<div className="ServiceImage">
					<img src={this.state.useDefaultImage ? this.state.defaultImageUrl : this.props.service.image} onError={this.onImageError} />
				</div>
			);
		}
	},



	/**
	* Change handlers
	*/

	onImageError: function () {
		this.setState({useDefaultImage: true});
	},

	onToggleService: function (service, e) {
		e.preventDefault();
		e.stopPropagation();

		if (this.props.serviceSelected) {
			this.removeService(service);
		} else {
			this.addService(service);
		}
	},



	/**
	* Helper functions
	*/

	addService: function (service) {
		var services = this.props.services.slice(0);
		services.push(service);
		//console.log('addService', service, services);
		this.props.onChange({target: {
			name: 'temp_services',
			value: services
		}});	
	},

	removeService: function (service) {
		var services = this.props.services.slice(0);
		var idx = -1;
		for (var i = 0, ilen = services.length; i < ilen; i++) {
			if (services[i].guid == service.guid) {
				idx = i;
				break;
			}
		}
		if (idx >= 0) {
			services.splice(idx, 1);
		}
		//console.log('removeService', service, services);
		this.props.onChange({target: {
			name: 'temp_services',
			value: services
		}});	
	},

	calculateTotalCost: function () {
		if (this.props.service.price == null) {
			return I18n.t('sola_search.price_varies');
		} else if (this.props.service.price.indexOf('+') != -1) {
			return '$' + numeral(parseFloat(this.props.service.price, 10)).format('0,0.00') + '+';
		} else {
			return '$' + numeral(parseFloat(this.props.service.price, 10)).format('0,0.00');
		}
	},

});