var BookingComplete = React.createClass({

	render: function () {
		return (
			<div className="BookingComplete">
				<div className="container">
					<div className="BookingCompleteHeader">
						<h2>{I18n.t('sola_search.booking_complete')}</h2>
						<p>{I18n.t('sola_search.thanks_for_choosing_sola')}</p>
						<div className="AddToCalendar">
							<a href="#" className="button primary">{I18n.t('sola_search.add_to_calendar')}</a>
						</div>
					</div>
					<div className="BookingCompleteBox">

					</div>
				</div>
			</div>
		);
	}

});