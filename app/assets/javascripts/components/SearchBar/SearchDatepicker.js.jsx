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
			var inputValue = $(self.refs.input).val()
			//console.log('date changing yo', inputValue, moment(inputValue, "MM/DD/YYYY"))
			if (inputValue && inputValue != '') {
				self.props.onChangeDate(moment(inputValue, "MM/DD/YYYY"));
			} else {
				self.props.onChangeDate('');
			}
		});
	},

	render: function () {
		//console.log('SearchDatePicker', this.props.date);

		return (
			<div className="SearchDatePicker">
				<span className="fa fa-calendar">&nbsp;</span>
				<input ref="input" type="text" placeholder="mm/dd/yyyy" />{/*placeholder={this.props.date.format('MM/DD/YY')}*/}
				{this.props.date ? <span className="fa fa-times" onClick={this.clearInput}>&nbsp;</span> : null}
			</div>
		);
	},

	/**
	* Change handler
	*/

	clearInput: function (event) {
		//console.log('clear input datepicker');
		$(this.refs.input).datepicker('setDate', '');//.datepicker('update', '');
		//$(this.refs.input).trigger('change');
	},

});