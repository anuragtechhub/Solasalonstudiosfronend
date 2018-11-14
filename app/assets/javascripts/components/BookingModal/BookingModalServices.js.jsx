var BookingModalServices = React.createClass({

	render: function () {
		var self = this;
		console.log('BookingModalServices', this.props);
		var services = this.props.professional.all_services.map(function (service) {
			return (
				<BookingModalServiceRow key={service.guid} service={service} serviceSelected={self.isServiceSelected(service)} toggleSwitch={true} />
			);
		});

		return (
			<div className="BookingModalServices">
				<div className="Body">
					<div className="ServicesRow">
						{services}
					</div>
				</div>
			</div>
		);
	},

	isServiceSelected: function (service) {
		for (var i = 0, ilen = this.props.services.length; i < ilen; i++) {
			if (service.guid == this.props.services[i].guid) {
				return true;
			}
		}

		return false;
	}

});