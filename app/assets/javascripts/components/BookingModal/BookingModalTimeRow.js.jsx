var BookingModalTimeRow = React.createClass({

	render: function () {
		var self = this;
		
		return (
			<div className="TimeRow">
				<span className="fa fa-clock-o">&nbsp;</span>
				<div className="Date">{moment(this.props.time.start).tz(self.props.professional.timezone).format('h:mm A')} &ndash; {moment(this.props.time.end).tz(self.props.professional.timezone).format('h:mm A')}</div>
				<a href="#" onClick={this.onChangeTime}>{I18n.t('sola_search.change_time')}</a>
			</div>
		);
	},
	
	onChangeTime: function (e) {
		e.preventDefault();

		this.props.onChange({
			target: {
				name: 'step',
				value: 'time'
			}
		});
	},

});