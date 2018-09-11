var ProfessionalAvailabilities = React.createClass({

	componentDidUpdate: function () {

	},

	render: function () {
		var self = this;
		
		if (this.props.availabilities && this.props.availabilities.length > 0) {
			var availabilities = this.props.availabilities.map(function (availability) {
				var times = availability.times.map(function (time) {
					return (
						<a href='#' key={time.start} className="availability-button">{moment(time.start).format('h:mma')}</a>
					);
				});
				return (
					<div className="availability-date" key={availability.date}>
						<div className="date">{moment(availability.date).format('ddd DD/YY')}</div>
						<div className="availabilities">
							{times}
						</div>
					</div>
				);
			});
			return (
				<div className="ProfessionalAvailabilities">
					<div className="ProfessionalAvailabilitiesWrapper">
						{availabilities}
					</div>
				</div>
			);
		} else {
			return (
				<div className="ProfessionalAvailabilities">
					<a href={this.props.booking_page_url} className="availability-button check-availability">{I18n.t('sola_search.check_availability')}</a>
				</div>
			);
		}
	}

});