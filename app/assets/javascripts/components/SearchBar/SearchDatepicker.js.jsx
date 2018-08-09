var SearchDatePicker = React.createClass({

	render: function () {
		return (
			<div className="SearchDatePicker">
				<span className="fa fa-calendar">&nbsp;</span>
				<input type="text" placeholder={moment(this.props.date).format('MM/DD/YY')} />
			</div>
		);
	}

});