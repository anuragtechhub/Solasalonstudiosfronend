var ProfessionalAvailabilities = React.createClass({

	getInitialState: function () {
		return {
			containerWidth: 0,
			scrollLeft: 0,
			scrollWidth: 0,
		}
	},	

	componentDidMount: function () {
		var self = this;

		$(window).on('resize.ProfessionalAvailabilities', function () {
			self.setState({containerWidth: $(self.refs.availabilities).width()});
		});
	},

	componentDidUpdate: function () {
		if (this.refs.availabilities && this.refs.availabilities.scrollWidth != this.state.scrollWidth) {
			this.setState({scrollWidth: this.refs.availabilities.scrollWidth, containerWidth: $(this.refs.availabilities).width()});
		}
	},

	render: function () {
		var self = this;

		//console.log('render ProfessionalAvailabilities name, containerWidth, scrollWidth, scrollLeft', this.props.full_name, this.state.containerWidth, this.state.scrollWidth, this.state.scrollLeft);
		
		if (this.props.availabilities && this.props.availabilities.length > 0) {
			var availabilities = this.props.availabilities.map(function (availability) {
				var times = availability.times.map(function (time) {
					return (
						<a href='#' key={time.start} className="availability-button" onClick={self.props.onShowBookingModal.bind(null, self.props.professional, time)}>{moment(time.start).format('h:mma')}</a>
					);
				});
				return (
					<div className="availability-date" key={availability.date}>
						<div className="date">{moment(availability.date).format('ddd DD/YY')}</div>
						<div className="availabilities" ref="availabilities">
							{times}
						</div>
					</div>
				);
			});
			return (
				<div className="ProfessionalAvailabilities">
					<div className="fa fa-chevron-left back-button" onClick={this.goBack} style={{display: this.state.scrollLeft <= 0 ? 'none' : 'block'}}></div>
					<div className="ProfessionalAvailabilitiesWrapper" ref="availabilities" onScroll={this.onScroll}>
						{availabilities}
					</div>
					<div className="fa fa-chevron-right forward-button" onClick={this.goForward} style={{display: (this.displayForwardButton() ? 'block' : 'none')}}></div>
				</div>
			);
		} else {
			return (
				<div className="ProfessionalAvailabilities UnknownAvailability">
					<a href={'http://' + this.props.booking_page_url} className="availability-button check-availability" target={this.props.booking_page_url}>{I18n.t('sola_search.check_availability')}</a>
				</div>
			);
		}
	},

	displayForwardButton: function () {
		if (this.state.containerWidth < this.state.scrollWidth) {
			if (this.state.scrollLeft + this.state.containerWidth >= this.state.scrollWidth) {
				return false;
			} else {
				return true;
			}
		} else if (this.state.scrollLeft + this.state.containerWidth >= this.state.scrollWidth) {
			return false;
		} else if (this.state.containerWidth < this.state.scrollWidth) { 
			return false;
		} else {
			return true;
		}
	},

	onScroll: function () {
		var $availabilities = $(this.refs.availabilities);
		//console.log('onscroll!', $availabilities.scrollLeft(), this.state.scrollWidth);
		this.setState({scrollLeft: $availabilities.scrollLeft()});
	},

	goBack: function () {
		var $availabilities = $(this.refs.availabilities);
		//console.log('go back!', this.refs.availabilities.scrollWidth, $availabilities.scrollLeft());
		$availabilities.animate({scrollLeft: $availabilities.scrollLeft() - 90}, 250);
	},

	goForward: function () {
		var $availabilities = $(this.refs.availabilities);
		//console.log('go forward!', this.refs.availabilities.scrollWidth, $availabilities.scrollLeft());
		if (this.state.scrollLeft == 0) {
			$availabilities.animate({scrollLeft: $availabilities.scrollLeft() + 60}, 250);
		} else {
			$availabilities.animate({scrollLeft: $availabilities.scrollLeft() + 90}, 250);
		}
	},

});