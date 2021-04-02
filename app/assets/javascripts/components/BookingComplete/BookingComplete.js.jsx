var BookingComplete = React.createClass({

	getInitialState: function () {
		return {
			defaultCoverImageUrl: 'https://s3.amazonaws.com/solasalonstudios/booknow-avatar.png', //https://s3.amazonaws.com/haubby-production-v1/users/avatars/000/000/064/original/image.jpg?1485837902
			glossDefaultCoverImageUrl: 'https://s3-us-west-2.amazonaws.com/glossgenius-static-v2/user_avatar.jpg',
			useDefaultCoverImage: false,
			height: 'auto',
			width: '110px',
			top: '0',
			left: '0',
		};
	},

	componentDidMount: function () {
		if (this.refs.add_to_calendar) {
			$(this.refs.add_to_calendar).add_to_calendar();
		}
	},

	render: function () {
		//console.log('this.props.time', this.props.time);
		var self = this;
		var service_description = '';
		var idx = 0;
		var services = this.props.services.map(function (service) {
			idx++;
			service_description += '* ' + service.name;
			if (idx < self.props.services.length) {
				service_description += '\r\n';
			}
			//console.log('service', service);
			return <BookingModalServiceRow key={service.guid} {...self.props} service={service} />
		});

		return (
			<div className="BookingComplete">
				<div className="container">
					<div className="BookingCompleteHeader">
						<h2>{I18n.t('sola_search.booking_complete')}</h2>
						<p>{I18n.t('sola_search.thanks_for_choosing_sola')}</p>
						<div className="AddToCalendar">
							<span className="add-to-calendar-wrapper" ref="add_to_calendar"
								 data-label={I18n.t('sola_search.add_to_calendar')}
								 data-title={I18n.t('sola_search.appointment_with_stylist', {stylist: this.props.professional.full_name})}
								 data-description={service_description}
								 data-address={this.props.professional.business_address.replace(/#/g, '')}
								 data-timezone={this.props.professional.timezone}
								 data-start={moment(this.props.time.start).tz(this.props.professional.timezone).format('YYYY-MM-DDTHH:mm:ss')}
								 data-end={moment(this.props.time.end).tz(this.props.professional.timezone).format('YYYY-MM-DDTHH:mm:ss')}></span>
						</div>
						{/*<span className="add-to-calendar-wrapper add-to-calendar" ref="add_to_calendar">
								<span className="title">{I18n.t('sola_search.appointment_with_stylist', {stylist: this.props.professional.full_name})}</span>
								<span className="description">{service_description}</span>
								<span className="address">{this.props.professional.business_address.replace(/#/g, '')}</span>
								<span className="start">{moment(this.props.time.start).tz(this.props.professional.timezone).format('YYYY-MM-DDTHH:mm:ss')}</span>
								<span className="end">{moment(this.props.time.end).tz(this.props.professional.timezone).format('YYYY-MM-DDTHH:mm:ss')}</span>
								<span className="timezone">{this.props.professional.timezone}</span>
							</span>*/}
					</div>
					<div className="BookingCompleteBox">

						<div className="Header">
							<div className="ProfessionalCoverImage">
								<a href={'//' + this.props.professional.booking_page_url} target={this.props.professional.booking_page_url} className="ga-et" data-gcategory="BookNow" data-gaction="View SolaGenius Professional Landing Page" data-glabel={this.props.professional.booking_page_url}>
									<img onLoad={this.onCoverImageLoad} style={{height: this.state.height, width: this.state.width, top: this.state.top, left: this.state.left}} src={this.state.useDefaultCoverImage ? this.state.defaultCoverImageUrl : (this.props.professional.cover_image != this.state.glossDefaultCoverImageUrl ? this.props.professional.cover_image : this.state.defaultCoverImageUrl)} alt={this.props.professional.full_name} onError={this.onCoverImageError} />
								</a>
							</div>
							<div className="ProfessionalInfo">
								<a href={'//' + this.props.professional.booking_page_url} target={this.props.professional.booking_page_url} className="ProfessionalName">{this.props.professional.full_name}</a>
								<div className="ProfessionalAddress">{this.props.professional.business_address}</div>
								<a href={'//' + this.props.professional.booking_page_url + (this.props.professional.booking_page_url.endsWith('/') ? '' : '/') + 'contact'} target={this.props.professional.booking_page_url + 'contact'} className="Contact ga-et" data-gcategory="BookNow" data-gaction="View SolaGenius Professional Contact Page" data-glabel={this.props.professional.booking_page_url + 'contact'}>{I18n.t('sola_search.contact')}&nbsp;{this.props.professional.full_name}</a>
							</div>
						</div>

						<div className="Body">
							<div className="DateRow">
								<span className="fa fa-calendar" role="presentation">&nbsp;</span>
								<div className="Date">{moment(this.props.time.start).tz(this.props.professional.timezone).format('MMMM Do YYYY')}</div>
							</div>

							<div className="TimeRow">
								<span className="fa fa-clock-o">&nbsp;</span>
								<div className="Date">{moment(this.props.time.start).tz(this.props.professional.timezone).format('h:mm A')} &ndash; {moment(this.props.time.end).tz(this.props.professional.timezone).format('h:mm A')}</div>
							</div>

							<div className="AddressRow">
								<span className="fa fa-map-marker" role="presentation">&nbsp;</span>
								<div className="Address">{this.props.professional.business_address}<br /><strong>{this.props.professional.business_name}</strong></div>
								<a href={'http://maps.google.com/maps?daddr=' + this.props.professional.business_address} target="_blank">{I18n.t('sola_search.map_it')}</a>
							</div>

							<div className="ServicesRow">
								<div className="ServiceTitle">{I18n.t(this.props.services.length == 1 ? 'sola_search.service' : 'sola_search.services')} ({this.props.services.length})</div>
								<div className="Services">{services}</div>
							</div>
						</div>

					</div>
				</div>
			</div>
		);
	},



	/**
	* Change handlers
	*/

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
    	var image_scale = self.scaleImage(img.width, img.height, 110, 110);
    	//console.log("onCoverImageLoad intrinsic size: " + img.width + "x" + img.height, image_scale);
    	self.setState({top: image_scale.targettop, left: image_scale.targetleft, width: image_scale.width, height: image_scale.height});
    };
		//})();

		// console.log('cover image load!', this.width, this.height, $(e.currentTarget).width(), $(e.currentTarget).width());
	},





	/**
	* Helper functions
	*/

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
	}

});