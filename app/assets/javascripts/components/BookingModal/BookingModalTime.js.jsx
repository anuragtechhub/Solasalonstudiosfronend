var BookingModalTime = React.createClass({

	componentDidMount: function () {
		if (this.refs.carousel) {
			$(this.refs.carousel).owlCarousel({
				navigation: true,
				navigationText: ['<span class="fa fa-chevron-left"></span>', '<span class="fa fa-chevron-right"></span>'],
				pagination: false,
				singleItem: true,
			});

			var owl = $(this.refs.carousel).data('owlCarousel');
			owl.jumpTo(2); // TODO
		}
	},

	render: function () {
		var days = this.props.professional.availabilities.map(function (availability) {
			var times = availability.times.map(function (time) {
				return (
					<div key={time.start + '_' + time.end}>
						<button type="button" className="time-button">{moment(time.start).format('h:mm A')} - {moment(time.end).format('h:mm A')}</button>
					</div>
				);
			});

			return (
				<div key={availability.date}>
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

});