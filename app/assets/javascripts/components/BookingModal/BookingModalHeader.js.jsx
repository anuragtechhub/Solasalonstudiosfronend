var BookingModalHeader = React.createClass({

	render: function () {
		return (
			<div className="BookingModalHeader">
				{this.renderBackButton()}
				{I18n.t('sola_search.book_appointment')}
				<div className="close-x"><span className="fa fa-2x fa-times-thin HideBookingModal" onClick={this.props.onHideBookingModal}></span></div>
			</div>
		);
	},

	renderBackButton: function () {
		if (this.props.step == 'info') {
			return <span className="fa fa-chevron-left BackButton" onClick={this.props.onBack}>&nbsp;</span>
		} else {
			return null;
		}
	},

});