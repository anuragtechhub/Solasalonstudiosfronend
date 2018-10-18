var BookingModalServiceRow = React.createClass({

	getInitialState: function () {
		return {
			defaultImageUrl: 'https://s3-us-west-2.amazonaws.com/glossgenius-static-v2/service_placeholder.png',
			useDefaultImage: false
		};
	},

	render: function () {
		//console.log('BookingModalService', this.props.service);

		return (
			<div className={"ServiceRow " + (this.props.service.image ? 'HasImage' : null)}>
				{this.renderServiceImage()}
				<div className="ServiceDetails">
					<div className="ServiceName">{this.props.service.name}</div>
					<div className="ServiceCostAndDuration">
						<span className="ServiceCost">${numeral(this.calculateTotalCost()).format('0,0.00')}</span> 
						<span className="Separator">&nbsp;</span> 
						<span className="ServiceDuration">{this.props.service.duration} {I18n.t('sola_search.min')}</span>
					</div>
				</div>
			</div>
		);
	},

	renderServiceImage: function () {
		if (this.props.service && this.props.service.image) {
			return (
				<div className="ServiceImage">
					<img src={this.state.useDefaultImage ? this.state.defaultImageUrl : this.props.service.image} onError={this.onImageError} />
				</div>
			);
		}
	},

	calculateTotalCost: function () {
		return parseFloat(this.props.service.price, 10);
	},

	onImageError: function () {
		this.setState({useDefaultImage: true});
	},

});