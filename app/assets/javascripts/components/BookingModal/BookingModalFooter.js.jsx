var BookingModalFooter = React.createClass({

	render: function () {
		//console.log('render BookingModalFooter', this.props.services);
		if (this.props.step == 'review') {
			return this.renderReviewFooter();
		} else if (this.props.step == 'date') {
			return this.renderDateFooter();
		} else if (this.props.step == 'time') {
			return this.renderTimeFooter();	
		} else if (this.props.step == 'services') {
			return this.renderServicesFooter();						
		} else if (this.props.step == 'info') {
			return this.renderInfoFooter();
		} else if (this.props.step == 'payment') {
			return this.renderPaymentFooter();
		} else {
			return null;
		}
	},

	renderDateFooter: function () {
		return (
			<div className="BookingModalFooter">
				<div className="Button">
					<button type="submit" className="primary" onClick={this.props.onSubmit}>{I18n.t('sola_search.save')}</button>
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

	renderPaymentFooter: function () {
		return (
			<div className="BookingModalFooter">
				<div className="Button">
					<button type="submit" className={"primary " + (this.props.ready ? '' : 'disabled')} onClick={this.props.onSubmit} disabled={!this.props.ready}>{I18n.t('sola_search.book_appointment')}</button>
				</div>
			</div>
		);
	},

	renderReviewFooter: function () {
		return (
			<div className="BookingModalFooter">
				<div className="Total">{I18n.t('sola_search.total')}: <strong>{this.calculateServicesTotal()}</strong></div>
				<div className="ChargedAfterAppointment">{I18n.t('sola_search.charged_after_appointment')}</div>
				<div className="Button">
					<button type="submit" className="primary" onClick={this.props.onSubmit}>{I18n.t((this.props.services.length == 1 ? 'sola_search.book_service' : 'sola_search.book_services'), {num: this.props.services.length})}</button>
				</div>
			</div>
		);
	},

	renderServicesFooter: function () {
		return (
			<div className="BookingModalFooter">
				<div className="Button">
					<button type="submit" className="primary" onClick={this.props.onSubmit}>{I18n.t('sola_search.save_services')}</button>
				</div>
			</div>
		);
	},

	renderTimeFooter: function () {
		return (
			<div className="BookingModalFooter">
				<div className="Button">
					<button type="submit" className="primary" onClick={this.props.onSubmit}>{I18n.t('sola_search.save')}</button>
				</div>
			</div>
		);
	},





	/**
	* Helper functions
	*/

	calculateServicesTotal: function () {
		var total = 0;
		var nullPrice = false;
		var hasPlus = false;

		for (var i = 0, ilen = this.props.services.length; i < ilen; i++) {
			//console.log('this.props.services[i]', this.props.services[i]);

			if (this.props.services[i].price == null) {
				nullPrice = true;
				break;
			} else if (this.props.services[i].price.indexOf('+') != -1) {
				hasPlus = true;
			}

			total = total + parseFloat(this.props.services[i].price, 10);
		}

		if (nullPrice) {
			total = I18n.t('sola_search.price_varies');
		}

		if (isNaN(total)) {
			return total;
		} else {
			if (hasPlus) {
				return '$' + numeral(total).format('0,0.00') + '+';
			} else {
				return '$' + numeral(total).format('0,0.00');
			}
		}
	},

});