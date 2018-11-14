var BookingComplete = React.createClass({
	
	getInitialState: function () {
		return {
			defaultCoverImageUrl: 'https://s3-us-west-2.amazonaws.com/glossgenius-static-v2/user_avatar.jpg',
			useDefaultCoverImage: false,
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
								 data-start={moment(this.props.time.start).format('MMMM D, YYYY HH:mm')}
								 data-end={moment(this.props.time.end).format('MMMM D, YYYY HH:mm')}></span>
						</div>
					</div>
					<div className="BookingCompleteBox">

						<div className="Header">
							<div className="ProfessionalCoverImage">
								<img src={this.state.useDefaultCoverImage ? this.state.defaultCoverImageUrl : this.props.professional.cover_image} alt={this.props.professional.full_name} onError={this.onCoverImageError} />
								<div className="Gradient"></div>
							</div>
							<div className="ProfessionalInfo">
								<div className="ProfessionalName">{this.props.professional.full_name}</div>
								<div className="ProfessionalAddress">{this.props.professional.business_address}</div>
								<a href={this.props.professional.booking_page_url} target={this.props.professional.booking_page_url} className="Contact">{I18n.t('sola_search.contact')}&nbsp;{this.props.professional.full_name}</a>
							</div>
						</div>

						<div className="Body">
							<div className="DateRow">
								<span className="fa fa-calendar">&nbsp;</span>
								<div className="Date">{moment(this.props.time.start).format('MMMM Do YYYY')}</div>
							</div>

							<div className="TimeRow">
								<span className="fa fa-clock-o">&nbsp;</span>
								<div className="Date">{moment(this.props.time.start).format('h:mm A')} &ndash; {moment(this.props.time.end).format('h:mm A')}</div>
							</div>

							<div className="AddressRow">
								<span className="fa fa-map-marker">&nbsp;</span>
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

});