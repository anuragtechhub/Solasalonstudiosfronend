var BookingModalHeader = React.createClass({

	render: function () {
		return (
			<div className="BookingModalHeader">
				{I18n.t('sola_search.book_appointment')}
				<div className="close-x"><span className="fa fa-2x fa-times-thin" onClick={this.props.onHideBookingModal}></span></div>
			</div>
		);
	}

});