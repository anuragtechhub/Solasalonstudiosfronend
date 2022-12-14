var ProfessionalResult = React.createClass({

	getInitialState: function () {
		return {
			availabilities: this.props.availabilities,
			date: this.props.date,
			defaultCoverImageUrl: 'https://s3.amazonaws.com/solasalonstudios/booknow-avatar.png',
			glossDefaultCoverImageUrl: 'https://s3-us-west-2.amazonaws.com/glossgenius-static-v2/user_avatar.jpg',
			loading: false,
			selectedService: this.props.selectedService || this.props.professional.matched_services[0],
			useDefaultCoverImage: false,
			height: 'auto',
			width: '130px',
			top: '0',
			left: '0',
		};
	},

	componentWillReceiveProps: function (nextProps) {
		if (!this.state.selectedService) {
			this.setState({selectedService: nextProps.professional.matched_services[0]});
		}
		if ((!this.state.availabilities || this.state.availabilities.length == 0) && nextProps.availabilities) {
			this.setState({availabilities: nextProps.availabilities});
		}
	},

	componentDidUpdate: function () {
		if (this.props.professional) {
			this.props.professional.availabilities = this.state.availabilities;
		}
	},



	/**
	* Render functions
	*/

	render: function () {
		//console.log('ProfessionalResult availabilities', this.props.availabilities, this.state.loading);
		//console.log('this.state.date', this.state.date);
		return (
			<div className="ProfessionalResult" onMouseEnter={this.onMouseEnter} onMouseLeave={this.onMouseLeave}>
				{/*<ProfessionalServicesDropdown booking_page_url={this.props.booking_page_url} services={this.props.all_services} />*/}
				<div className="ProfessionalCoverImage">
					<a href={'//' + this.bookingPageUrl(this.props.professional.booking_page_url)} target={this.props.professional.booking_page_url} className="ga-et" data-gcategory="BookNow" data-gaction="View SolaGenius Professional Page" data-glabel={this.props.professional.booking_page_url}>
						<img style={{height: this.state.height, width: this.state.width, top: this.state.top, left: this.state.left}} src={this.state.useDefaultCoverImage ? this.state.defaultCoverImageUrl : (this.props.cover_image != this.state.glossDefaultCoverImageUrl ? this.props.cover_image : this.state.defaultCoverImageUrl)} alt={this.props.full_name} onError={this.onCoverImageError} onLoad={this.onCoverImageLoad} className="ga-et" data-gcategory="BookNow" data-gaction="View SolaGenius Professional Page" data-glabel={this.props.professional.booking_page_url} />
					</a>
				</div>
				
				<div className="ProfessionalResultDetails">
					<a href={'//' + this.bookingPageUrl(this.props.professional.booking_page_url)} target={this.props.professional.booking_page_url} className="ProfessionalName">{this.props.full_name}</a>
					<div className="ProfessionalAddress">{this.props.business_address}</div>
					<ProfessionalServicesDropdown
						services={this.props.professional.matched_services}
						selectedService={this.state.selectedService}
						onChange={this.onChangeSelectedService}
					/>
					<ProfessionalAvailabilities 
						availabilities={this.state.availabilities} 
						booking_page_url={this.props.booking_page_url} 
						full_name={this.props.full_name} 
						onShowBookingModal={this.props.onShowBookingModal} 
						onLoadMoreAvailabilities={this.onLoadMoreAvailabilities}
						professional={this.props.professional} 
						selectedService={this.state.selectedService}
					/>
				</div>
				{this.state.loading ? <div className="loading"><div className="spinner"></div></div> : null}
			</div>
		);
	},



	/**
	* Change handlers
	*/

	onChangeSelectedService: function (service) {
		var self = this;
		//console.log('selectedService', service);
		this.setState({loading: true, selectedService: service}, function () {
			self.getAvailabilities();
		});
	},

	onCoverImageError: function () {
		this.setState({useDefaultCoverImage: true});
	},

	onCoverImageLoad: function (e) {
		var self = this;
		//console.log('onCoverImageLoad', $(e.target).attr('src'));
		//(function () {
		var img = new Image;
		img.src = $(e.target).attr('src');
    img.onload = function() {
    	var image_scale = self.scaleImage(img.width, img.height, 130, 130);
    	//console.log("onCoverImageLoad intrinsic size: " + img.width + "x" + img.height, image_scale);
    	self.setState({top: image_scale.targettop, left: image_scale.targetleft, width: image_scale.width, height: image_scale.height});
    };
		//})();

		// console.log('cover image load!', this.width, this.height, $(e.currentTarget).width(), $(e.currentTarget).width());
	},

	onLoadMoreAvailabilities: function (e) {
		e.preventDefault();
		//console.log('onLoadMoreAvailabilities!');
		var self = this;
		
		var services_guids = {};
		services_guids[this.props.professional.guid] = this.state.selectedService.guid;
		//console.log('services_guids', services_guids);
		var date = this.state.date.clone().add(3, 'days')
		self.setState({loading: true, date: date});

		$.ajax({
			data: {
				date: date.tz(self.props.professional.timezone).format("YYYY-MM-DD"),
				services_guids: services_guids
			},
	    headers: {
	    	"api_key": this.props.gloss_genius_api_key,
	    	"device_id": this.props.fingerprint,
	    },
			method: 'POST',
	    url: this.props.gloss_genius_api_url + 'availabilities',
		}).done(function (response) {
			//console.log('getAvailabilities response', JSON.parse(response));
			var availabilities = self.state.availabilities.slice(0);
			var new_availabilities = JSON.parse(response)[self.props.professional.guid];

			for (var j = 0, jlen = new_availabilities.length; j < jlen; j++) {
				//console.log('new_availabilities[i]', new_availabilities[i][j].date);
				var match = false;
				for (var k = 0, klen = self.state.availabilities.length; k < klen; k++) {
					if (self.state.availabilities[k].date == new_availabilities[j].date) {
						//console.log('match!');
						match = true;
						break;
					}
				}
				
				if (!match) {
					availabilities.push(new_availabilities[j]);
				}
			}
			
			self.setState({availabilities: availabilities, loading: false});
		}); 		
	},

	onMouseEnter: function () {
		//console.log('onMouseEnter', this.props.professional.location_latitude, this.props.professional.location_longitude, this.props.map);
		if (this.props.map) {
			this.props.map.panTo(new google.maps.LatLng(this.props.professional.location_latitude, this.props.professional.location_longitude));
			this.props.map.setZoom(16);
		}
	},

	onMouseLeave: function () {
		//console.log('onMouseLeave', this.props.map, this.props.center, this.props.zoom);
		if (this.props.map && this.props.center && this.props.zoom) {
			this.props.map.panTo(this.props.center);
			this.props.map.setZoom(this.props.zoom);
		}
	},



	/**
	* Helper functions
	*/

	bookingPageUrl: function (url) {
		var params = '?utm_source=sola&utm_campaign=sola_booknow&utm_medium=referral';
		
		if (url.endsWith('/')) {
			return  url.substring(0, url.length - 1) + params;
		} else {
			return url + params;
		}
	},

	getAvailabilities: function () {
		var self = this;
		
		var services_guids = {};
		services_guids[this.props.professional.guid] = this.state.selectedService.guid;
		//console.log('services_guids', services_guids);

		$.ajax({
			data: {
				date: this.props.date.tz(self.props.professional.timezone).format("YYYY-MM-DD"),
				services_guids: services_guids
			},
	    headers: {
	    	"api_key": this.props.gloss_genius_api_key,
	    	"device_id": this.props.fingerprint,
	    },
			method: 'POST',
	    url: this.props.gloss_genius_api_url + 'availabilities',
		}).done(function (response) {
			//console.log('getAvailabilities response', JSON.parse(response));
			self.setState({availabilities: JSON.parse(response)[self.props.professional.guid], loading: false});
		}); 
	},

	scaleImage: function (srcwidth, srcheight, targetwidth, targetheight, fLetterBox) {
    var result = { width: 0, height: 0, fScaleToTargetWidth: true };

    if ((srcwidth <= 0) || (srcheight <= 0) || (targetwidth <= 0) || (targetheight <= 0)) {
        return result;
    }

    // scale to the target width
    var scaleX1 = targetwidth;
    var scaleY1 = (srcheight * targetwidth) / srcwidth;

    // scale to the target height
    var scaleX2 = (srcwidth * targetheight) / srcheight;
    var scaleY2 = targetheight;

    // now figure out which one we should use
    var fScaleOnWidth = (scaleX2 > targetwidth);
    if (fScaleOnWidth) {
        fScaleOnWidth = fLetterBox;
    }
    else {
       fScaleOnWidth = !fLetterBox;
    }

    if (fScaleOnWidth) {
        result.width = Math.floor(scaleX1);
        result.height = Math.floor(scaleY1);
        result.fScaleToTargetWidth = true;
    }
    else {
        result.width = Math.floor(scaleX2);
        result.height = Math.floor(scaleY2);
        result.fScaleToTargetWidth = false;
    }
    result.targetleft = Math.floor((targetwidth - result.width) / 2);
    result.targettop = Math.floor((targetheight - result.height) / 2);

    return result;
	},

});