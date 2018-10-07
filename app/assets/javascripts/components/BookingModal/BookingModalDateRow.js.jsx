var BookingModalDateRow = React.createClass({

	render: function () {
		return (
			<div className="DateRow">
				<span className="fa fa-calendar">&nbsp;</span>
				<div className="Date">{moment(this.props.time.start).format('MMMM do YYYY')}</div>
				<a href="#">{I18n.t('sola_search.change_date')}</a>
			</div>
		);
	}

});