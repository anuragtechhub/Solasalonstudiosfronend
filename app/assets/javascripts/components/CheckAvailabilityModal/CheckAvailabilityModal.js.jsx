var CheckAvailabilityModal = React.createClass({

	getInitialState: function () {
		return {
			availabilities: [],
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

		if ((!this.props.professional && nextProps.professional) || (this.props.professional && nextProps.professional && this.props.professional.guid != nextProps.professional.guid)) {
			//console.log('setting availabilities!');
			this.setState({availabilities: nextProps.professional.availabilities})
		}

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

	componentDidUpdate: function (prevProps, prevState) {
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

		if ((this.props.professional && !prevProps.professional) || (this.props.professional && prevProps.professional && this.props.professional.guid != prevProps.professional.guid)) {
			this.loadAvailability();
		}
	},



	/**
	* Render functions
	*/

	render: function () {
		if (this.props.visible) {
			//console.log('CheckAvailabilityModal', this.props.professional, this.state.availabilities);

			return (
				<div className="CheckAvailabilityModalOverlay HideCheckAvailabilityModal">
					<div className={"CheckAvailabilityModal" + (this.state.fullHeight ? ' FullHeight ' : '') + (this.state.fullWidth ? ' FullWidth ' : '')} ref="CheckAvailabilityModal">
						<CheckAvailabilityModalHeader {...this.props} {...this.state} />
						<CheckAvailabilityModalBody {...this.props} {...this.state} />
						<CheckAvailabilityModalFooter {...this.props} {...this.state} onSubmit={this.onSubmit} />
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

	onSubmit: function (e) {
		e.stopPropagation();
		e.preventDefault();

		//console.log('onSubmit CheckAvailabilityModal');
		this.loadAvailability();
	},



	/**
	* Helper functions
	*/

	loadAvailability: function () {		
		var self = this;
		var services_guids = this.getServicesGuids();
		
		self.setState({loading: true});

		$.ajax({
			data: {
				date: this.state.date.add(3, 'days').format("YYYY-MM-DD"),
				services_guids: services_guids
			},
	    headers: {
	    	"api_key": this.props.gloss_genius_api_key,
	    	"device_id": this.props.fingerprint,
	    },
			method: 'POST',
	    url: this.props.gloss_genius_api_url + 'availabilities',
		}).done(function (response) {
			var new_availabilities = JSON.parse(response);
			//console.log('loadAvailability response', new_availabilities, self.state.availabilities);
			var availabilities = self.state.availabilities.slice(0);
			
			// if (self.state.availabilities) {
			// 	//console.log('availabilities already defined!');
			for (var i in new_availabilities) {
				
				
				for (var j = 0, jlen = new_availabilities[i].length; j < jlen; j++) {
					//console.log('new_availabilities[i]', new_availabilities[i][j].date);
					var match = false;
					for (var k = 0, klen = self.state.availabilities.length; k < klen; k++) {
						if (self.state.availabilities[k].date == new_availabilities[i][j].date) {
							//console.log('match!');
							match = true;
							break;
						}
					}
					
					if (!match) {
						availabilities.push(new_availabilities[i][j]);
					}
				}
				
			}
			self.setState({loading: false, availabilities: availabilities});
			// 	self.setState({availabilities: self.state.availabilities});
			// } else {
			// 	self.setState({availabilities: new_availabilities});
			// }
		}); 		
	},

	getServicesGuids: function () {
		var guids = {};

		guids[this.props.professional.guid] = [];

		for (var i = 0, ilen = this.props.professional.matched_services.length; i < ilen; i++) {
			guids[this.props.professional.guid].push(this.props.professional.matched_services[i].guid);
		}

		return guids;
	},	

});