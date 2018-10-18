var BookingComplete = React.createClass({
	
	getInitialState: function () {
		return {
			defaultCoverImageUrl: 'https://s3-us-west-2.amazonaws.com/glossgenius-static-v2/user_avatar.jpg',
			useDefaultCoverImage: false,
		};
	},

	render: function () {
		//console.log('this.props.professional', this.props.professional);
		var services = this.props.services.map(function (service) {
			return <BookingModalServiceRow key={service} {...self.props} service={service} />
		});

		return (
			<div className="BookingComplete">
				<div className="container">
					<div className="BookingCompleteHeader">
						<h2>{I18n.t('sola_search.booking_complete')}</h2>
						<p>{I18n.t('sola_search.thanks_for_choosing_sola')}</p>
						<div className="AddToCalendar">
							<a href="#" className="button primary">{I18n.t('sola_search.add_to_calendar')}</a>
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
								<a href="#">{I18n.t('sola_search.map_it')}</a>
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