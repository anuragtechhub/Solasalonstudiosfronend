var BookingModal = React.createClass({

	getInitialState: function () {
		return {
			date: this.props.date ? moment(this.props.date) : moment(),
			temp_date: this.props.date ? moment(this.props.date) : moment(),

			time: this.props.time,
			temp_time: this.props.time,

			services: this.props.services,
			temp_services: this.props.services,

			email_address: Cookies.get('email_address') || '',
			error: null,
			fullHeight: false,
			fullWidth: false,
			loading: false,
			phone_number: Cookies.get('phone_number') || '',
			ready: false,
			step: this.props.step || 'review',
			your_name: Cookies.get('your_name') || '',
		}
	},

	componentDidMount: function () {
		var self = this;
		var $window = $(window);

		// handle booking modal sizing
		$window.on('resize.BookingModal', function () {
			var width = $window.width();
			var height = $window.height();
			var fullWidth = width <= 600;
			var fullHeight = height <= 612;

			//console.log('window', width, height, 'BookingModal', b_width, b_height);

			if (fullWidth != self.state.fullWidth || fullHeight != self.state.fullHeight) {
				self.setState({fullHeight: fullHeight, fullWidth: fullWidth});
			}
		}).trigger('resize.BookingModal');
	},

	componentWillReceiveProps: function (nextProps) {
		if (nextProps.step != this.state.step) {
			this.setState({step: nextProps.step, error: null});
		}
		//if (!this.state.time && nextProps.time) {//} && nextProps.time.start != this.state.time.start && nextProps.time.end != this.state.time.end) {
			this.setState({time: nextProps.time, temp_time: nextProps.time});
		//}
		//if (this.state.services.length == 0 && nextProps.services.length) {
			this.setState({services: nextProps.services, temp_services: nextProps.services});
		//}
		//if (!moment(nextProps.date).isSame(this.state.date)) {
			this.setState({date: moment(nextProps.date), temp_date: moment(nextProps.date)});
		//}

		if (nextProps.visible && !this.props.visible) {
			ga('solasalonstudios.send', 'event', 'BookNow', 'Open Booking Modal', JSON.stringify({
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
		//console.log('BookingModal', this.props.time);

		if (this.props.visible) {
			return (
				<div className="BookingModalOverlay HideBookingModal">
					<div className={"BookingModal" + (this.state.fullHeight ? ' FullHeight ' : '') + (this.state.fullWidth ? ' FullWidth ' : '')} ref="BookingModal">
						<BookingModalHeader {...this.props} {...this.state} onBack={this.onBack} />
						<BookingModalBody {...this.props} {...this.state} onChange={this.onChange} onSubmit={this.onSubmit} />
						<BookingModalFooter {...this.props} {...this.state} onSubmit={this.onSubmit} />
						{this.state.loading ? <div className="loading"><div className="spinner"></div></div> : null}
						{this.renderBookingCompleteForm()}
					</div>
				</div>
			);
		} else {
			return null;
		}
	},

	renderBookingCompleteForm: function () {
		//console.log('booking complete form', JSON.stringify(this.state.time));
		return (
			<form ref="BookingCompleteForm" method="post" action={this.props.booking_complete_path} style={{display: 'none'}}>
				<input name="professional" type="hidden" value={JSON.stringify(this.props.professional)} />
				<input name="services" type="hidden" value={JSON.stringify(this.state.services)} />
				<input name="time" type="hidden" value={JSON.stringify(this.state.time)} />
			</form>
		);
	},



	/**
	* Change handlers
	*/

	onBack: function () {
		if (this.state.step == 'info') {
			this.setState({step: 'review', ready: false, error: null});
		} else if (this.state.step == 'date') {
			this.setState({step: 'review', ready: false, temp_date: this.state.date, error: null});
		} else if (this.state.step == 'time') {
			if (this.state.temp_time == null) {
				this.setState({error: I18n.t('sola_search.please_select_a_time')});
			} else {
				this.setState({step: 'review', ready: false, temp_time: this.state.time, error: null});	
			}
		} else if (this.state.step == 'services') {
			this.setState({step: 'review', ready: false, temp_services: this.state.services, error: null});						
		} else if (this.state.step == 'payment') {
			this.setState({step: 'info', ready: false, error: null});
		}
	},

	onChange: function (e) {
		if (e && e.target) {
			//console.log('onChange', e.target.name, e.target.value);
			this.state[e.target.name] = e.target.value;
			this.setState(this.state, function () {
				Cookies.set(e.target.name, e.target.value);
			});
		}
	},

	onSubmit: function (e) {
		var self = this;

		//console.log('onSubmit!', this.state.step, this.props.booking_complete_path);

		if (e && e.preventDefault && e.stopPropagation) {
			e.preventDefault();
			e.stopPropagation();
		}

		if (this.state.step == 'review') {
			this.setState({step: 'info', ready: false, error: null});
		} else if (this.state.step == 'date') {
			// DATE
			if (moment(this.state.date).isSame(this.state.temp_date)) {
				//console.log('same date...', this.state.temp_date)
				this.setState({step: 'review', ready: false, date: this.state.temp_date, error: null});
			} else {
				//console.log('not the same date!', this.state.temp_date)
				this.setState({ready: false, error: null, loading: true, date: this.state.temp_date}, function () {
					self.refreshAvailabilityThenGotoTimeStep();
				});
			}
		} else if (this.state.step == 'time') {
			if (this.state.temp_time == null) {
				this.setState({error: I18n.t('sola_search.please_select_a_time')});
			} else {
				var moment_date = moment(this.state.temp_time.start);
				//console.log('setting moment_date', moment_date);
				this.setState({step: 'review', ready: false, date: moment_date, temp_date: moment_date, time: this.state.temp_time, error: null});
			}
		} else if (this.state.step == 'services') {
			// SERVICES
			if (this.arraysEqual(this.state.services, this.state.temp_services)) {
				this.setState({step: 'review', ready: false, services: this.state.temp_services, error: null});	
			} else {
				this.setState({ready: false, error: null, loading: true}, function () {
					self.refreshAvailabilityThenGotoTimeStep();
				});
			}			
		} else if (this.state.step == 'info') {
			if (!this.validateEmail(this.state.email_address)) {
				this.setState({error: I18n.t('sola_search.please_enter_your_email_address')});
			} else if (this.state.your_name == '') {
				this.setState({error: I18n.t('sola_search.please_enter_your_name')});
			} else if (this.state.phone_number == '') {
				this.setState({error: I18n.t('sola_search.please_enter_your_phone_number')});
			} else {
				this.clientCheck();
			}
		} else if (this.state.step == 'payment') {
			this.book();
		}
	},



	/**
	* Helper functions
	*/

	arraysEqual: function (arr1, arr2) {
    if(arr1.length !== arr2.length)
        return false;
    for(var i = arr1.length; i--;) {
        if(arr1[i] !== arr2[i])
            return false;
    }

    return true;
	},

	book: function () {
		var self = this;

		var service_guids = [];
		for (var i = 0, ilen = this.state.services.length; i < ilen; i++) {
			service_guids.push(this.state.services[i].guid);
		}
		//console.log('book it', service_guids, this.state.time, this.state.services, self.calculateServicesTotal());

		this.setState({loading: true});

		$.ajax({
			data: {
				name: this.state.your_name,
				phone: this.state.phone_number,
				email: this.state.email_address,
				stripe_token: this.state.stripe_token,
				start_time: this.state.time.start,
				service_guids: service_guids,
				user_guid: this.props.professional.guid,
			},
	    headers: {
	    	"api_key": this.props.gloss_genius_api_key,
	    	"device_id": this.props.fingerprint,
	    },
			method: 'POST',
	    url: this.props.gloss_genius_api_url + 'book',
		}).complete(function (response) {
			//console.log('book is done', response.responseText);
			var json_response = JSON.parse(response.responseText);
			//console.log('book response', json_response);
			if (json_response && json_response.error) {
				//console.log('booking ERROR');
				self.setState({loading: false, error: json_response.error});
			} else {
				//console.log('booking SUCCESS!!!', self.props.professional, self.props.location_id);
				ga('solasalonstudios.send', 'event', 'BookNow', 'Booking Complete', JSON.stringify({
					date: self.state.date.format('YYYY-MM-DD'),
					fingerprint: self.props.fingerprint,
					lat: self.props.lat,
					lng: self.props.lng,
					location_id: self.props.location_id || self.props.professional.org_location_id,
					location: self.props.location,
					query: self.props.query,
					services: self.state.services,
					total: self.calculateServicesTotal(),
					time_range: moment(self.state.time.start).tz(self.props.professional.timezone).format('h:mm A') + ' - ' + moment(self.state.time.end).tz(self.props.professional.timezone).format('h:mm A'),
					booking_user: {
						name: self.state.your_name,
						phone: self.state.phone_number,
						email: self.state.email_address,
					},
					org_user_id: self.props.professional.org_user_id,
					referring_url: self.props.referring_url,
				}));
				$(self.refs.BookingCompleteForm).submit();
			}
		}); 
	},

	/**
	* Helper functions
	*/

	calculateServicesTotal: function () {
		var total = 0;
		var nullPrice = false;
		var hasPlus = false;

		for (var i = 0, ilen = this.state.services.length; i < ilen; i++) {
			//console.log('this.props.services[i]', this.props.services[i]);

			if (this.state.services[i].price == null) {
				nullPrice = true;
				break;
			} else if (this.state.services[i].price.indexOf('+') != -1) {
				hasPlus = true;
			}

			total = total + parseFloat(this.state.services[i].price, 10);
		}

		if (nullPrice) {
			total = I18n.t('sola_search.price_varies');
		}

		if (isNaN(total)) {
			return total;
		} else {
			if (hasPlus) {
				return '$' + numeral(total).format('0,0.00') + '+';
			} else {
				return '$' + numeral(total).format('0,0.00');
			}
		}
	},

	clientCheck: function () {
		var self = this;

		this.setState({loading: true});
		
		$.ajax({
			data: {
				name: this.state.your_name,
				phone: this.state.phone_number,
				email: this.state.email_address,
				user_guid: this.props.professional.guid,
			},
	    headers: {
	    	"api_key": this.props.gloss_genius_api_key,
	    	"device_id": this.props.fingerprint,
	    },
			method: 'GET',
	    url: this.props.gloss_genius_api_url + 'client-check',
		}).done(function (response) {
			var json_response = JSON.parse(response);
			//console.log('clientCheck response', json_response);
			if (json_response && json_response.error) {
				self.setState({loading: false, error: json_response.error});
			} else if (json_response.require_card !== true) {
				self.book();
			} else {
				self.setState({loading: false, step: 'payment', ready: false, error: null});
			}
		}); 
	},

	refreshAvailabilityThenGotoTimeStep: function () {
		var self = this;

		//console.log("refresh availability, then goto 'time' step");
		
		var services_guids = {};
		var services = [];
		for (var i = 0, ilen = this.state.temp_services.length; i < ilen; i++) {
			//services_guids[this.props.professional.guid] = this.state.services[i].guid;
			services.push(this.state.temp_services[i].guid);
		}
		services_guids[this.props.professional.guid] = services;
		
		//console.log('services_guids', services_guids);
		//console.log('refreshAvailabilityThenGotoTimeStep this.state.date', moment(this.state.date).format("YYYY-MM-DD"));
		$.ajax({
			data: {
				date: moment(this.state.date).tz(self.props.professional.timezone).format("YYYY-MM-DD"),
				services_guids: services_guids
			},
	    headers: {
	    	"api_key": this.props.gloss_genius_api_key,
	    	"device_id": this.props.fingerprint,
	    },
			method: 'POST',
	    url: this.props.gloss_genius_api_url + 'availabilities',
		}).done(function (response) {
			var json_response = JSON.parse(response);
			//console.log('getAvailabilities response', json_response, json_response[self.props.professional.guid]);
			if (json_response && json_response[self.props.professional.guid] && json_response[self.props.professional.guid].length) {
				self.props.professional.availabilities = json_response[self.props.professional.guid];
				self.setState({loading: false, step: 'time', ready: false, error: null, services: self.state.temp_services, date: self.state.temp_date, temp_time: null});
			} else {
				self.setState({loading: false, ready: false, error: I18n.t('sola_search.no_availability')});
			}
		}); 
	},

	validateEmail: function (email) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(String(email).toLowerCase());
	},

});