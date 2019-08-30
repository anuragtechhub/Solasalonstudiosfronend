var CheckAvailabilityModalFooter = React.createClass({

	render: function () {
		// console.log('render CheckAvailabilityModalFooter', this.props.services);
		return (
			<div className="CheckAvailabilityModalFooter">
				<div className="Button">
					<button type="submit" className="primary" onClick={this.props.onSubmit}>{I18n.t('sola_search.load_more')}</button>
				</div>
			</div>
		);
	},

});