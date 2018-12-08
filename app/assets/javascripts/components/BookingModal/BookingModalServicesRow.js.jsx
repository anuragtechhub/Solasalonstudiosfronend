var BookingModalServicesRow = React.createClass({

	render: function () {
		var self = this;
		var services = this.props.services.map(function (service) {
			return <BookingModalServiceRow key={service.guid} {...self.props} service={service} />
		});

		return (
			<div className="ServicesRow">
				<div className="ServiceTitle">{I18n.t(this.props.services.length == 1 ? 'sola_search.service' : 'sola_search.services')} ({this.props.services.length})</div>
				<a href="#" onClick={this.onChangeServices}>{I18n.t('sola_search.add_remove_services')}</a>

				<div className="Services">{services}</div>
			</div>
		);
	},

	onChangeServices: function (e) {
		e.preventDefault();

		this.props.onChange({
			target: {
				name: 'step',
				value: 'services'
			}
		});
	},	

});