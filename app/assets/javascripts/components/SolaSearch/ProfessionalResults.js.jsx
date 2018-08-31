var ProfessionalResults = React.createClass({
	
	render: function () {
		var professionals = this.props.professionals.map(function (professional) {
			return <ProfessionalResult key={professional.booking_page_url} {...professional} />
		});

		return (
			<div className="ProfessionalResults">
				{professionals}
			</div>
		);
	},

});