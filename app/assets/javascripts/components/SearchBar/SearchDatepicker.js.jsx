var SearchDatePicker = React.createClass({

	componentDidMount: function () {
		var self = this;
		var $datepicker = $(this.refs.input).datepicker({
			autoclose: true,
			startDate: new Date(),
			templates: {
		    leftArrow: '<i class="fa fa-caret-left"></i>',
		    rightArrow: '<i class="fa fa-caret-right"></i>'
			}
		});

		$datepicker.datepicker('setDate', this.props.date.toDate());
		$datepicker.datepicker().on('changeDate', function () {
			self.props.onChangeDate(moment($(self.refs.input).val(), "MM/DD/YYYY"));
		});
	},

	render: function () {
		return (
			<div className="SearchDatePicker">
				<span className="fa fa-calendar">&nbsp;</span>
				<input ref="input" type="text" placeholder={this.props.date.format('MM/DD/YY')} />
			</div>
		);
	}

});