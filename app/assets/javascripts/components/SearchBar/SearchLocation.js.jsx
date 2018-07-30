var SearchLocation = React.createClass({

	render: function () {
		return (
			<div className="SearchLocation">
				<input type="text" placeholder={i18n.t('sola_search.search_bar.current_location')} />
			</div>
		);
	}

});