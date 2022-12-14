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

					{this.state.ready ? null : <p style={{textAlign: 'center'}}><span className="spinner spinner-sm spinner-static" style={{top: 4, right: 2}}></span> <em>{I18n.t('sola_search.loading')}</em></p>}
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
		var self = this;
		if (this.state.stripe && this.state.card) {
			this.state.stripe.createToken(this.state.card).then(function(result) {
				//console.log('createToken?', result);
		    if (result.error) {
		      // Inform the customer that there was an error.
		      var errorElement = document.getElementById('card-errors');
		      errorElement.textContent = result.error.message;
		    } else {
		      // Send the token to your server.
		      //console.log('set stripe_token', result.token);
					self.props.onChange({target: {
						name: 'stripe_token',
						value: result.token.id
					}});	
		    }
		  });
		} else {
			//console.log('cannot create token', this.state.stripe, this.state.card);
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
		    fontFamily: "'Lato', Arial, sans-serif",
		    fontSize: '14px',
		    color: "#000000",
		  }
		};

		// Create an instance of the card Element.
		var card = elements.create('card', {style: style});

		card.addEventListener('ready', function(event) {
			self.setState({ready: true});
			self.props.onChange({target: {
				name: 'ready',
				value: true
			}})
		});

		card.addEventListener('change', function(event) {
			//console.log('card changed???', event);

		  var displayError = document.getElementById('card-errors');
		  if (event.error) {
		    displayError.textContent = event.error.message;
		  } else {
		    displayError.textContent = '';
		  }

		  if (event.complete) {
		  	//console.log('card is complete!, lets get a token');
		  	self.createToken();
		  }
		});

		card.mount('#card-element');

		this.setState({stripe: stripe, elements: elements, card: card});
	},

});