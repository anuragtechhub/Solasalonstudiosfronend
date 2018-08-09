var SearchDatePicker = React.createClass({

	componentDidMount: function () {
		$(this.refs.input).datepicker({
			
		});
	},

	render: function () {
		return (
			<div className="SearchDatePicker">
				<span className="fa fa-calendar">&nbsp;</span>
				<input ref="input" type="text" placeholder={moment(this.props.date).format('MM/DD/YY')} />
			</div>
		);
	}

});