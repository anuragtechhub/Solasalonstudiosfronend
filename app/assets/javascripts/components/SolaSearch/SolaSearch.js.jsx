var SolaSearch = React.createClass({

	getInitialState: function () {
		//console.log('SolaSearch getInitialState', this.props.gloss_genius_api_key, this.props.gloss_genius_api_url);
		return {
			availabilities: this.props.availabilities || {},
			booking_complete_path: this.props.booking_complete_path,
			bookingModalVisible: false,
			date: this.props.date ? moment(this.props.date, "YYYY-MM-DD") : moment(),
			display: this.props.displayMode || 'desktop',
			//end_of_results: this.props.professionals && this.props.professionals.length >= 9 ? false : true,
			error: null,
			fingerprint: this.props.fingerprint,
			gloss_genius_api_key: this.props.gloss_genius_api_key,
			gloss_genius_api_url: this.props.gloss_genius_api_url,
			gloss_genius_stripe_key: this.props.gloss_genius_stripe_key,
			lat: this.props.lat,
			lng: this.props.lng,
			location: this.props.location,
			location_id: this.props.location_id,
			location_name: this.props.location_name,
			locations: this.props.locations || [],
			loading: false,
			mode: this.props.mode || 'list',
			pagination: true,
			professional: this.props.professional,
			professionals: this.props.professionals || [],
			query: this.props.query,
			radius: 25,
			sideTabVisible: true,
			sideTabPopUpVisible: false,
			services: [],
			step: this.props.step || 'review',
			results_path: this.props.results_path,
			time: this.props.time,
			zoom: this.props.zoom,
		};
	},

	componentDidMount: function () {
		this.getAvailabilities(this.getServicesGuids());

		var self = this;
		var $window = $(window);

		// handle booking modal sizing
		$window.on('resize.SolaSearch', function () {
			var width = $window.width();
			
			//console.log('resize SolaSearch', width);
			if (width <= 991 && self.state.display != 'mobile') {
				self.setState({display: 'mobile'});
			} else if (width > 991 && self.state.display != 'desktop') {
				self.setState({display: 'desktop'});
			}
		}).trigger('resize.SolaSearch');

		// track search results
		ga('solasalonstudios.send', 'event', 'BookNow', 'Results', JSON.stringify({
			number_of_results: this.state.professionals.length >= 10 ? '10+' : this.state.professionals.length,
			date: this.state.date.format('YYYY-MM-DD'),
			fingerprint: this.state.fingerprint,
			lat: this.state.lat,
			lng: this.state.lng,
			location_id: this.state.location_id,
			location: this.state.location,
			query: this.state.query,
		}));
	},



	/**
	* Render functions
	*/

	render: function () {
		//console.log('render SolaSearch professionals', this.state.professionals);
		//console.log('render SolaSearch locations', this.state.locations);
		
		return (
			<div className={"SolaSearch " + this.state.mode}>
				<ProfessionalResults 
					availabilities={this.state.availabilities} 
					date={this.state.date} 
					end_of_results={this.state.end_of_results}
					fingerprint={this.state.fingerprint}
					lat={this.state.lat}
					lng={this.state.lng}
					loading={this.state.loading}
					location={this.state.location}
					location_id={this.state.location_id}
					location_name={this.state.location_name}
					fingerprint={this.state.fingerprint}
					gloss_genius_api_key={this.state.gloss_genius_api_key}
					gloss_genius_api_url={this.state.gloss_genius_api_url}
					onLoadMoreProfessionals={this.onLoadMoreProfessionals}
					onShowBookingModal={this.onShowBookingModal}
					pagination={this.state.pagination}
					professionals={this.state.professionals} 
					query={this.state.query} 
					results_path={this.state.results_path} 
				/>
				<LocationsMap 
					display={this.state.display}
					lat={this.state.lat} 
					lng={this.state.lng} 
					locations={this.state.locations} 
					mode={this.state.mode}
					onChangeLocationId={this.onChangeLocationId}
					onShowSideTabPopUp={this.onShowSideTabPopUp}
					zoom={this.state.zoom}
				/>
				<BookingModal 
					booking_complete_path={this.state.booking_complete_path}
					date={this.state.time ? this.state.time.start : new Date()}
					fingerprint={this.state.fingerprint}
					gloss_genius_api_key={this.state.gloss_genius_api_key}
					gloss_genius_api_url={this.state.gloss_genius_api_url}
					gloss_genius_stripe_key={this.state.gloss_genius_stripe_key}
					lat={this.state.lat}
					lng={this.state.lng}
					location={this.state.location}
					location_id={this.state.location_id}
					location_name={this.state.location_name}
					onHideBookingModal={this.onHideBookingModal}
					professional={this.state.professional} 
					query={this.state.query} 
					services={this.state.services}
					step={this.state.step}
					time={this.state.time} 
					visible={this.state.bookingModalVisible} 
				/>
				<SideTabPopUpModal visible={this.state.sideTabPopUpVisible} onHideSideTabPopUpModal={this.onHideSideTabPopUpModal} />
				{this.renderFloatingToggleButton()}
				{
					!this.state.sideTabPopUpVisible && this.state.sideTabVisible 
					?
					<div className="side-tab">
						<span className="text" onClick={this.onShowSideTabPopUp}>{I18n.t('sola_search.dont_see_your_sola_professional')}</span>
						<span className="close-x" onClick={this.onHideSideTab}></span>
					</div>
					: 
					null
				}
			</div>
		);
	},

	renderFloatingToggleButton: function () {
		if (this.state.display == 'mobile' && !this.state.bookingModalVisible) {
			if (this.state.mode == 'list') {
				return (
					<button type="button" className="primary FloatingToggle" onClick={this.onChangeMode.bind(this, 'map')}><span className="fa fa-map">&nbsp;</span> {I18n.t('sola_search.map')}</button>
				);
			} else {
				return (
					<button type="button" className="primary FloatingToggle" onClick={this.onChangeMode.bind(this, 'list')}><span className="fa fa-list">&nbsp;</span> {I18n.t('sola_search.list')}</button>
				);
			}
		}
	},



	/**
	* Change handlers
	*/

  onHideSideTab: function () {
  	this.setState({sideTabVisible: false});
  },

	onChangeLocationId: function (location_id) {
		this.setState({location_id: location_id});
	},

	onChangeMode: function (mode) {
		this.setState({mode: mode});
	},

	onHideBookingModal: function (e) {
		if (e && e.target) {
			var $target = $(e.target);
			if ($target.hasClass('HideBookingModal')) {
				this.setState({bookingModalVisible: false, professional: null, time: null, services: [], step: 'review'});
			} else {
				// do nothing 
			}
		} else {
			this.setState({bookingModalVisible: false, professional: null, time: null, services: [], step: 'review'});
		}
	},

  onShowSideTabPopUp: function () {
  	this.setState({sideTabPopUpVisible: true});
  },

  onHideSideTabPopUpModal: function () {
  	this.setState({sideTabPopUpVisible: false});
  },

	onShowBookingModal: function (professional, time, selectedService, event) {
		if (event && typeof event.preventDefault == 'function') {
			event.preventDefault();
		}

		//console.log('onShowBookingModal', professional, time, selectedService);
		//console.log('onShowBookingModal', professional, time, professional.matched_services[0]);
		this.setState({bookingModalVisible: true, professional: professional, time: time, services: [selectedService]});
	},

	onLoadMoreProfessionals: function () {
		var self = this;

		//console.log('load more!', self.state.professionals[self.state.professionals.length - 1].cursor);
		
		self.setState({loading: true});

		$.ajax({
			data: {
				date: self.state.date.format('YYYY-MM-DD'),
				fingerprint: self.state.fingerprint,
				lat: self.state.lat,
				lng: self.state.lng,
				location_id: self.state.location_id,
				location: self.state.location,
				query: self.state.query,
				search_after: self.state.professionals[self.state.professionals.length - 1].cursor,
				fingerprint: self.props.fingerprint,
			},
			method: 'POST',
	    url: self.props.results_path + '.json',
		}).done(function (response) {
			//console.log('onLoadMoreProfessionals response', response);
			//end_of_results
			if (response && response.length) {
				var professionals = self.state.professionals.slice(0);

				if (self.allUniqueProfessionals(professionals, response)) {
					//console.log("yes, all unique");
					professionals.push.apply(professionals, response);
					self.setState({loading: false, professionals: professionals, }, function () {
						self.getAvailabilities(self.getServicesGuids(response));
					});
				} else {
					//console.log("no, not all unique -- only set uniques");
					professionals.push.apply(professionals, response);
					professionals = self.getUniqueProfessionals(professionals, response);
					self.setState({loading: false, pagination: false, professionals: professionals, end_of_results: true}, function () {
						self.getAvailabilities(self.getServicesGuids(response));
					});
				}
			} else {
				self.setState({loading: false, pagination: false, end_of_results: true});
			}	
		}); 
	},



	/**
	* Helper functions
	*/

	allUniqueProfessionals: function (professionals, response) {
		for (var p = 0, plen = professionals.length; p < plen; p++) {
			for (var r =0, rlen = response.length; r < rlen; r++) {
				if (professionals[p].org_user_id == response[r].org_user_id) {
					return false;
				}
			}
		}

		return true;
	},

	getUniqueProfessionals: function (professionals) {
		var prop = 'org_user_id';
    return professionals.filter((obj, pos, arr) => {
    	return arr.map(mapObj => mapObj[prop]).indexOf(obj[prop]) === pos;
    });
	},

	getAvailabilities: function (services_guids) {
		var self = this;
		
		//console.log('services_guids', services_guids);

		$.ajax({
			data: {
				date: this.state.date.format("YYYY-MM-DD"),
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
			//console.log('getAvailabilities response', new_availabilities);
			if (self.state.availabilities) {
				//console.log('availabilities already defined!');
				for (var i in new_availabilities) {
					self.state.availabilities[i] = new_availabilities[i];
				}
				self.setState({availabilities: self.state.availabilities});
			} else {
				self.setState({availabilities: new_availabilities});
			}
		}); 
	},

	getServicesGuids: function (professionals) {
		var guids = {};

		if (!professionals) {
			professionals = this.state.professionals;
		}

		for (var i = 0, ilen = professionals.length; i < ilen; i++) {
			guids[professionals[i].guid] = [];
			
			// only one service id per professional to start with
			if (professionals[i].matched_services.length >= 1) {
				guids[professionals[i].guid].push(professionals[i].matched_services[0].guid);
			}
			// for (var j = 0, jlen = this.state.professionals[i].matched_services.length; j < jlen; j++) {
			// 	guids[this.state.professionals[i].guid].push(this.state.professionals[i].matched_services[j].guid);
			// }
		}

		return guids;
	},

});