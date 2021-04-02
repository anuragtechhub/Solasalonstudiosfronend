var BookingModalDateRow = React.createClass({

	render: function () {
		var self = this;

		return (
			<div className="DateRow">
				<span className="fa fa-calendar" role="presentation">&nbsp;</span>
				<div className="Date">{moment(this.props.date).tz(self.props.professional.timezone).format('MMMM Do YYYY')}</div>
				<a href="#" onClick={this.onChangeDate}>{I18n.t('sola_search.change_date')}</a>
			</div>
		);
	},

	onChangeDate: function (e) {
		e.preventDefault();

		this.props.onChange({
			target: {
				name: 'step',
				value: 'date'
			}
		});
	},

});