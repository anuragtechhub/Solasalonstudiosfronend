var BookingModalTime = React.createClass({

	componentDidMount: function () {
		if (this.refs.carousel) {
			var $carousel = $(this.refs.carousel);
			
			$carousel.owlCarousel({
				navigation: true,
				navigationText: ['<span class="fa fa-chevron-left"></span>', '<span class="fa fa-chevron-right"></span>'],
				pagination: false,
				singleItem: true,
			});

			var owl = $carousel.data('owlCarousel');
			//console.log('this.props.date', this.props.date, this.props.date.format('YYYY-MM-DD'), $carousel.find('[data-date="' + this.props.date.format('YYYY-MM-DD') + '"]').data('idx'));
			owl.jumpTo($carousel.find('[data-date="' + this.props.date.format('YYYY-MM-DD') + '"]').data('idx'));
		}
	},

	render: function () {
		var self = this;
		var idx = 0;
		var days = this.props.professional.availabilities.map(function (availability) {
			var times = availability.times.map(function (time) {
				return (
					<div key={time.start + '_' + time.end}>
						<button type="button" className={"time-button " + (self.isActive(time) ? 'active' : '')} onClick={self.onChangeTime.bind(self, time)}>{moment(time.start).format('h:mm A')} - {moment(time.end).format('h:mm A')}</button>
					</div>
				);
			});

			//console.log('availability.date',  availability.date, moment(availability.date).format('YYYY-MM-DD'));

			return (
				<div key={availability.date} data-date={moment(availability.date).format('YYYY-MM-DD')} data-idx={idx++}>
					<h2 className="text-center">{moment(availability.date).format('MMMM Do')}</h2>
					<div className="times">{times}</div>
				</div>
			);
		});

		return (
			<div className="BookingModalTime">
				<div className="Body">
					<div ref="carousel">
						{days}
					</div>
				</div>
			</div>
		);
	},



	/**
	* Change handlers
	*/

	onChangeTime: function (time, e) {
		e.stopPropagation();
		e.preventDefault();
		//console.log('onChangeTime', time);
		this.props.onChange({target: {
			name: 'temp_time',
			value: time
		}});		
	},



	/**
	* Helper functions
	*/

	isActive: function (time) {
		if (time.start == this.props.temp_time.start && time.end == this.props.temp_time.end) {
			return true;
		} else {
			return false;
		}
	},

});