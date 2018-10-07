var BookingModalFooter = React.createClass({

	render: function () {
		//console.log('render BookingModalFooter', this.props.services);
		if (this.props.step == 'review') {
			return this.renderReviewFooter();
		} else if (this.props.step == 'info') {
			return this.renderInfoFooter();
		} else {
			return null;
		}
	},

	renderReviewFooter: function () {
		return (
			<div className="BookingModalFooter">
				<div className="Total">{I18n.t('sola_search.total')}: <strong>${numeral(this.calculateServicesTotal()).format('0,0.00')}</strong></div>
				<div className="ChargedAfterAppointment">{I18n.t('sola_search.charged_after_appointment')}</div>
				<div className="Button">
					<button type="submit" className="primary" onClick={this.props.onSubmit}>{I18n.t((this.props.services.length == 1 ? 'sola_search.book_service' : 'sola_search.book_services'), {num: this.props.services.length})}</button>
				</div>
			</div>
		);
	},

	renderInfoFooter: function () {
		return (
			<div className="BookingModalFooter">
				<div className="Button">
					<button type="submit" className="primary" onClick={this.props.onSubmit}>{I18n.t('sola_search.continue')}</button>
				</div>
			</div>
		);
	},



	/**
	* Helper functions
	*/

	calculateServicesTotal: function () {
		var total = 0;

		for (var i = 0, ilen = this.props.services.length; i < ilen; i++) {
			total = total + parseFloat(this.props.services[i].price, 10);
		}

		return total;
	},

});