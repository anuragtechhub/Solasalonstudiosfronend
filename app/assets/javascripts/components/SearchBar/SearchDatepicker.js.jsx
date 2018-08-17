var SearchDatePicker = React.createClass({

	componentDidMount: function () {
		var $datepicker = $(this.refs.input).datepicker({
			startDate: new Date(),
			templates: {
		    leftArrow: '<i class="fa fa-caret-left"></i>',
		    rightArrow: '<i class="fa fa-caret-right"></i>'
			}
		});

		$datepicker.datepicker('setDate', this.props.date);
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