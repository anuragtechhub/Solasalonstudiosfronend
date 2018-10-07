var BookingModalTimeRow = React.createClass({

	render: function () {
		return (
			<div className="TimeRow">
				<span className="fa fa-clock-o">&nbsp;</span>
				<div className="Date">{moment(this.props.time.start).format('h:mm A')} &ndash; {moment(this.props.time.end).format('h:mm A')}</div>
				<a href="#">{I18n.t('sola_search.change_time')}</a>
			</div>
		);
	}

});