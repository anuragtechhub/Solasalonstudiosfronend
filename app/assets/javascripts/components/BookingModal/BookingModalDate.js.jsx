var BookingModalDate = React.createClass({

	componentDidMount: function () {
		var self = this;
		var $datepicker = $(this.refs.datepicker).datepicker({
			//autoclose: true,
			startDate: new Date(),
			templates: {
		    leftArrow: '<i class="fa fa-caret-left"></i>',
		    rightArrow: '<i class="fa fa-caret-right"></i>'
			}
		});

		$datepicker.datepicker('setDate', this.props.date.toDate());
		$datepicker.datepicker().on('changeDate', function () {
			var newDate = moment($(self.refs.datepicker).datepicker('getDate'), "MM/DD/YYYY");
			//console.log('changeDate', newDate.toDate());
			self.props.onChange({target: {
				name: 'temp_date',
				value: newDate
			}});
		});
	},

	// componentWillReceiveProps: function (nextProps) {
	// 	if (!nextProps.date.isSame(this.props.date)) {
	// 		$(this.refs.datepicker).datepicker('setDate', nextProps.date.toDate());
	// 	}
	// },

	render: function () {		
		return (
			<div className="BookingModalDate">
				<div className="Body">
					<div ref="datepicker"></div>
				</div>
			</div>
		);
	},

});