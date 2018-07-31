var StylistResult = React.createClass({

	render: function () {
		return (
			<div className="StylistResult">
				<StylistName name={name} />
				<StylistAddress address={address} />
			</div>
		);
	},

});