var CheckAvailabilityModal = React.createClass({

	getInitialState: function () {
		return {
			date: this.props.date ? moment(this.props.date) : moment(),
			temp_date: this.props.date ? moment(this.props.date) : moment(),

			error: null,
			fullHeight: false,
			fullWidth: false,
			loading: false,
			ready: false,
		}
	},

	componentDidMount: function () {
		var self = this;
		var $window = $(window);

		// handle booking modal sizing
		$window.on('resize.CheckAvailabilityModal', function () {
			var width = $window.width();
			var height = $window.height();
			var fullWidth = width <= 600;
			var fullHeight = height <= 612;

			//console.log('window', width, height, 'CheckAvailabilityModal', b_width, b_height);

			if (fullWidth != self.state.fullWidth || fullHeight != self.state.fullHeight) {
				self.setState({fullHeight: fullHeight, fullWidth: fullWidth});
			}
		}).trigger('resize.CheckAvailabilityModal');
	},

	componentWillReceiveProps: function (nextProps) {
		this.setState({date: moment(nextProps.date), temp_date: moment(nextProps.date)});

		if (nextProps.visible && !this.props.visible) {
			ga('solasalonstudios.send', 'event', 'BookNow', 'Open Check Availability Modal', JSON.stringify({
				date: this.state.date.format('YYYY-MM-DD'),
				fingerprint: this.props.fingerprint,
				lat: this.props.lat,
				lng: this.props.lng,
				location_id: this.props.location_id,
				location: this.props.location,
				query: this.props.query,
				referring_url: this.props.referring_url,
			}));
		}
	},

	componentDidUpdate: function () {
		// disable / enable scrolling
		if (this.props.visible) {
			$('html, body').css({
		    overflow: 'hidden',
		    height: '100%'
			});
		} else {
			$('html, body').css({
		    overflow: 'auto',
		    height: 'auto'
			});
		}
	},



	/**
	* Render functions
	*/

	render: function () {
		//console.log('CheckAvailabilityModal', this.props.time);

		if (this.props.visible) {
			return (
				<div className="CheckAvailabilityModalOverlay HideCheckAvailabilityModalModal">
					<div className={"CheckAvailabilityModal" + (this.state.fullHeight ? ' FullHeight ' : '') + (this.state.fullWidth ? ' FullWidth ' : '')} ref="CheckAvailabilityModal">
						<CheckAvailabilityModalHeader {...this.props} {...this.state} />
						<CheckAvailabilityModalBody {...this.props} {...this.state} />
						<CheckAvailabilityModalFooter {...this.props} {...this.state} />
						{this.state.loading ? <div className="loading"><div className="spinner"></div></div> : null}
					</div>
				</div>
			);
		} else {
			return null;
		}
	},



	/**
	* Change handlers
	*/



	/**
	* Helper functions
	*/

});