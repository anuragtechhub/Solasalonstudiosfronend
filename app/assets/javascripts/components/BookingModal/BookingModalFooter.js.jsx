var BookingModalFooter = React.createClass({

	render: function () {
		console.log('render BookingModalFooter', this.props.services);

		return (
			<div className="BookingModalFooter">
				<div className="Total">{I18n.t('sola_search.total')}: <strong>$25.00</strong></div>
				<div className="ChargedAfterAppointment">{I18n.t('sola_search.charged_after_appointment')}</div>
				<div className="Button">
					<button type="submit" className="primary">{I18n.t((this.props.services.length == 1 ? 'sola_search.book_service' : 'sola_search.book_services'), {num: this.props.services.length})}</button>
				</div>
			</div>
		);
	},

});