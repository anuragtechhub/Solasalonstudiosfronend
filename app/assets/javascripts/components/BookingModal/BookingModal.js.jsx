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
			var fullHeight = height <= 600;

			//console.log('window', width, height, 'BookingModal', b_width, b_height);

			if (fullWidth != self.state.fullWidth || fullHeight != self.state.fullHeight) {
				self.setState({fullHeight: fullHeight, fullWidth: fullWidth});
			}
		}).trigger('resize.BookingModal');
	},

	componentWillReceiveProps: function (nextProps) {
		if (nextProps.step != this.state.step) {
			this.setState({step: nextProps.step});
		}
		if (!this.state.time && nextProps.time) {//} && nextProps.time.start != this.state.time.start && nextProps.time.end != this.state.time.end) {
			this.setState({time: nextProps.time, temp_time: nextProps.time});
		}
		//if (this.state.services.length == 0 && nextProps.services.length) {
			this.setState({services: nextProps.services, temp_services: nextProps.services});
		//}
		if (!moment(nextProps.date).isSame(this.state.date)) {
			this.setState({date: moment(nextProps.date), temp_date: moment(nextProps.date)});
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
		//console.log('BookingModal', this.props.services);

		if (this.props.visible) {
			return (
				<div className="BookingModalOverlay HideBookingModal" onClick={this.props.onHideBookingModal}>
					<div className={"BookingModal" + (this.state.fullHeight ? ' FullHeight ' : '') + (this.state.fullWidth ? ' FullWidth ' : '')} ref="BookingModal">
						<BookingModalHeader {...this.props} {...this.state} onBack={this.onBack} />
						<BookingModalBody {...this.props} {...this.state} onChange={this.onChange} />
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
		return (
			<form ref="BookingCompleteForm" method="post" action={this.props.booking_complete_path} style={{display: 'none'}}>
				<input name="professional" type="hidden" value={JSON.stringify(this.props.professional)} />
				<input name="services" type="hidden" value={JSON.stringify(this.props.services)} />
				<input name="time" type="hidden" value={JSON.stringify(this.props.time)} />
			</form>
		);
	},



	/**
	* Change handlers
	*/

	onBack: function () {
		if (this.state.step == 'info') {
			this.setState({step: 'review', ready: false});
		} else if (this.state.step == 'date') {
			this.setState({step: 'review', ready: false, temp_date: this.state.date});
		} else if (this.state.step == 'time') {
			this.setState({step: 'review', ready: false, temp_time: this.state.time});	
		} else if (this.state.step == 'services') {
			this.setState({step: 'review', ready: false, temp_services: this.state.services});						
		} else if (this.state.step == 'payment') {
			this.setState({step: 'info', ready: false});
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
		//console.log('onSubmit!', this.props.booking_complete_path);

		if (e && e.preventDefault && e.stopPropagation) {
			e.preventDefault();
			e.stopPropagation();
		}

		if (this.state.step == 'review') {
			this.setState({step: 'info', ready: false});
		} else if (this.state.step == 'date') {
			this.setState({step: 'review', ready: false, date: this.state.temp_date});
		} else if (this.state.step == 'time') {
			this.setState({step: 'review', ready: false, time: this.state.temp_time});
		} else if (this.state.step == 'services') {
			this.setState({step: 'review', ready: false, services: this.state.temp_services});						
		} else if (this.state.step == 'info') {
			this.clientCheck();
		} else if (this.state.step == 'payment') {
			this.book();
			// submit hidden form with booking info
			//$(this.refs.BookingCompleteForm).submit();
		}
	},



	/**
	* Helper functions
	*/

	book: function () {
		var self = this;

		var service_guids = [];
		for (var i = 0, ilen = this.state.services.length; i < ilen; i++) {
			service_guids.push(this.state.services[i].guid);
		}
		console.log('book it', service_guids, this.state.services);
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
				console.log('booking ERROR');
				self.setState({loading: false, error: json_response.error});
			} else {
				console.log('booking SUCCESS!!!');
				$(self.refs.BookingCompleteForm).submit();
			}
		}); 
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
			console.log('clientCheck response', JSON.parse(response));
			if (JSON.parse(response).require_card !== true) {
				self.book();
			} else {
				self.setState({loading: false, step: 'payment', ready: false});
			}
		}); 
	},

});