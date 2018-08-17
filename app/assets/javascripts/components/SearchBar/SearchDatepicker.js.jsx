var SearchDatePicker = React.createClass({

	componentDidMount: function () {
		$(this.refs.input).datepicker({
			templates: {
		    leftArrow: '<i class="fa fa-caret-left"></i>',
		    rightArrow: '<i class="fa fa-caret-right"></i>'
			}
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