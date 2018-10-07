var BookingModalServicesRow = React.createClass({

	render: function () {
		var self = this;
		var services = this.props.services.map(function (service) {
			return <BookingModalServiceRow key={service} {...self.props} service={service} />
		});

		return (
			<div className="ServicesRow">
				<div className="ServiceTitle">{I18n.t(this.props.services.length == 1 ? 'sola_search.service' : 'sola_search.services')} ({this.props.services.length})</div>
				<a href="#">{I18n.t('sola_search.add_service')}</a>

				<div className="Services">{services}</div>
			</div>
		);
	}

});