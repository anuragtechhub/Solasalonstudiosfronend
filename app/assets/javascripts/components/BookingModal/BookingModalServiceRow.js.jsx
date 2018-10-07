var BookingModalServiceRow = React.createClass({

	render: function () {
		//console.log('BookingModalService', this.props.service);

		return (
			<div className="ServiceRow">
				<div className="ServiceName">{this.props.service.name}</div>
				<div className="ServiceCostAndDuration">
					<span className="ServiceCost">${numeral(this.calculateTotalCost()).format('0,0.00')}</span> 
					<span className="Separator">&nbsp;</span> 
					<span className="ServiceDuration">{this.props.service.duration} {I18n.t('sola_search.min')}</span>
				</div>
			</div>
		);
	},

	calculateTotalCost: function () {
		return parseFloat(this.props.service.cost, 10);
	}

});