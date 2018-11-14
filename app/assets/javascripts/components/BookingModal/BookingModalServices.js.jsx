var BookingModalServices = React.createClass({

	render: function () {
		console.log('BookingModalServices', this.props.professional.all_services);
		var services = this.props.professional.all_services.map(function (service) {
			return (
				<BookingModalServiceRow key={service.guid} service={service} toggleSwitch={true} />
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

});