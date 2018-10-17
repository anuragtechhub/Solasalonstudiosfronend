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

		console.log('bookingmodaldate', this.props.date.toDate());

		$datepicker.datepicker('setDate', this.props.date.toDate());
		$datepicker.datepicker().on('changeDate', function () {
			var newDate = moment($(self.refs.datepicker).val(), "MM/DD/YYYY");
			console.log('changeDate', newDate);
		});
	},

	componentWillReceiveProps: function (nextProps) {
		if (!nextProps.date.isSame(this.props.date)) {
			$(this.refs.datepicker).datepicker('setDate', nextProps.date.toDate());
		}
	},

	render: function () {
		console.log('BookingModalDate this.props.date', this.props.date);
		
		return (
			<div className="BookingModalDate">
				<div className="Body">
					<div ref="datepicker"></div>
				</div>
			</div>
		);
	},

});