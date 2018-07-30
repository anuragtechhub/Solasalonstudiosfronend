var SearchDatePicker = React.createClass({

	render: function () {
		return (
			<div className="SearchDatePicker">
				<span className="fa fa-calendar">&nbsp;</span>
				<input type="text" placeholder={this.props.date.toString('mm/dd/yy')} />
			</div>
		);
	}

});