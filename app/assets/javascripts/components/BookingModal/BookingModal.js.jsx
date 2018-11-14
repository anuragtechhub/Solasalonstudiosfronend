var BookingModal = React.createClass({

	getInitialState: function () {
		return {
			date: this.props.date ? moment(this.props.date) : moment(),
			email_address: Cookies.get('email_address') || '',
			fullHeight: false,
			fullWidth: false,
			loading: false,
			phone_number: Cookies.get('phone_number') || '',
			ready: false,
			step: this.props.step || 'review',
			time: this.props.time,
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
			this.setState({time: nextProps.time});
		}
		if (!moment(nextProps.date).isSame(this.state.date)) {
			this.setState({date: moment(nextProps.date)});
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
			this.setState({step: 'review', ready: false});
		} else if (this.state.step == 'time') {
			this.setState({step: 'review', ready: false});	
		} else if (this.state.step == 'services') {
			this.setState({step: 'review', ready: false});						
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
			this.setState({step: 'review', ready: false});
		} else if (this.state.step == 'time') {
			this.setState({step: 'review', ready: false});
		} else if (this.state.step == 'services') {
			this.setState({step: 'review', ready: false});						
		} else if (this.state.step == 'info') {
			this.clientCheck();
			//this.setState({step: 'payment', ready: false});
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

		console.log('book it', this.state.services);

		this.setState({loading: true});

		$.ajax({
			data: {
				name: this.state.your_name,
				phone: this.state.phone_number,
				email: this.state.email_address,
				stripe_token: this.state.stripe_token,
				start_time: this.state.time.start,
				service_guids: this.state.services,
				user_guid: this.props.professional.guid,
			},
	    headers: {
	    	"api_key": this.props.gloss_genius_api_key,
	    	"device_id": this.props.fingerprint,
	    },
			method: 'GET',
	    url: this.props.gloss_genius_api_url + 'client-check',
		}).done(function (response) {
			console.log('book response', JSON.parse(response));
			// if (JSON.parse(response).require_card !== true) {
			// 	self.book();
			// } else {
			// 	self.setState({loading: false, step: 'payment', ready: false});
			// }
			$(self.refs.BookingCompleteForm).submit();
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
			//console.log('clientCheck response', JSON.parse(response));
			if (JSON.parse(response).require_card !== true) {
				self.book();
			} else {
				self.setState({loading: false, step: 'payment', ready: false});
			}
		}); 
	},

});