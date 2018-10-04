var BookingModal = React.createClass({

	render: function () {
		console.log('BookingModal', this.props);

		if (this.props.visible) {
			return (
				<div className="BookingModalOverlay" onClick={this.props.onHideBookingModal}>
					<div className="BookingModal">
						{this.renderHeader()}
						{this.renderBody()}
						{this.renderFooter()}
					</div>
				</div>
			);
		} else {
			return null;
		}
	},

	renderBody: function () {
		return (
			<div className="BookingModalBody">
				BODY
			</div>
		);
	},

	renderFooter: function () {
		return (
			<div className="BookingModalFooter">
				FOOTER
			</div>
		);
	},

	renderHeader: function () {
		return (
			<div className="BookingModalHeader">
				{I18n.t('sola_search.book_appointment')}
				<div className="close-x"><span className="fa fa-2x fa-times-thin" onClick={this.props.onHideBookingModal}></span></div>
			</div>
		);
	},

});