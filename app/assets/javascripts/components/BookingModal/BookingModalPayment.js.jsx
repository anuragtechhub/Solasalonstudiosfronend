var BookingModalPayment = React.createClass({

	getInitialState: function () {
		return {
			stripe: null,
			elements: null,
			card: null,
			ready: false,
		};
	},

	componentDidMount: function () {
		this.initStripeElements();
	},



	/**
	* Render functions
	*/

	render: function () {
		return (
			<div className="BookingModalPayment">
				<div className="Body">
					<h2>{I18n.t('sola_search.payment_details')}</h2>

					{this.state.ready ? null : <p style={{textAlign: 'center'}}><span className="spinner spinner-sm spinner-static"></span> <em>{I18n.t('sola_search.loading')}</em></p>}
					<div id="card-element" style={{visibility: this.state.ready ? 'visible' : 'hidden'}}></div>
					<div id="card-errors" role="alert"></div>
				</div>
			</div>
		);
	},




	/**
	* Helper functions
	*/

	createToken: function () {
		if (this.state.stripe && this.state.card) {
			this.state.stripe.createToken(this.state.card).then(function(result) {
		    if (result.error) {
		      // Inform the customer that there was an error.
		      var errorElement = document.getElementById('card-errors');
		      errorElement.textContent = result.error.message;
		    } else {
		      // Send the token to your server.
		      console.log('send token to server!', result.token);
		    }
		  });
		} else {
			console.log('cannot create token', this.state.stripe, this.state.card);
		}
	},

	initStripeElements: function () {
		var self = this;
		var stripe = Stripe(this.props.gloss_genius_stripe_key);
		var elements = stripe.elements();

		//console.log('BookingModalPayment', this.props.gloss_genius_stripe_key, stripe, elements);

		var style = {
		  base: {
		    // Add your base input styles here. For example:
		    family: "'Lato', Arial, sans-serif",
		    fontSize: '14px',
		    color: "#000000",
		  }
		};

		// Create an instance of the card Element.
		var card = elements.create('card', {style: style});

		card.addEventListener('ready', function(event) {
			console.log('we ready')
			self.setState({ready: true});
		});

		card.addEventListener('change', function(event) {
		  var displayError = document.getElementById('card-errors');
		  if (event.error) {
		    displayError.textContent = event.error.message;
		  } else {
		    displayError.textContent = '';
		  }
		});

		card.mount('#card-element');

		this.setState({stripe: stripe, elements: elements, card: card});
	},

});