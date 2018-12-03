var BookNowReferral = React.createClass({

  getInitialState: function () {
    return {
      height: 600,
      width: 1200,
      subdomain: null,
      url: '',
      modalVisible: false,
    };
  },

  componentDidMount: function () {
    var self = this;
    var $window = $(window);

    window.onShowBookNowReferralModal = function () {
      self.setState({modalVisible: true});
      $('body').css('overflow', 'hidden');
    };

    $window.on('resize.BookNowReferral', function () {
      var window_height = $window.height();
      var window_width = $window.width();

      if (window_width <= 1200) {
        self.setState({width: window_width});
      }

      if (window_height <= 600) {
        self.setState({height: window_height});
      }
    }).trigger('resize');
  },

  render: function () {
    return (
      <div className="BookNowReferral">
        {this.state.modalVisible ? this.renderModal() : null}
        {this.state.modalVisible ? <div className="BookNowOverlay" onClick={this.onHideModal}>&nbsp;</div> : null}
      </div>
    );
  },

  renderFrame1: function () {
    return (
      <div className="found">
        <h3 className="text-uppercase">Enter your SolaGenius Website</h3>
        <p>Copy the business URL assigned to you through the SolaGenius app and paste it below to receive your referral link.</p>
        <div className="inputs">
          <form onSubmit={this.onSubmit}>
            <div className="col-input">
              <input type="text" className="form-control input-block" value={this.state.url} onChange={this.onChangeUrl} onFocus={this.onFocusUrl} onBlur={this.onBlurUrl} />
            </div>
            <div className="col-button">
              <button type="submit" className="btn">Get custom referral link</button>
            </div>
          </form>
        </div>
      </div>
    );
  },

  renderFrame2: function () {
    return (
      <div className="found">
        <h3 className="text-uppercase">Your Custom Referral Link is Here!</h3>
        <p>Share your link via text, email, or social with friends who should use SolaGenius for their business.</p>
        <div className="inputs">
          <form onSubmit={this.onCopy}>
            <div className="col-input">
              <input type="text" className="form-control input-block" value={'https://glossgenius.com/invite/' + this.state.subdomain} />
            </div>
            <div className="col-button">
              <button type="submit" className="btn">Copy Link</button>
            </div>
          </form>
        </div>
      </div>
    );
  },

  renderModal: function () {
    return (
      <div className="BookNowModal" style={{width: this.state.width, height: this.state.height, marginLeft: -(this.state.width / 2), marginTop: -(this.state.height / 2)}}>
        <div className="ink-cloud-left"></div>
        <div className="ink-cloud-right"></div>
        <div className="fa fa-times" onClick={this.onHideModal}></div>
        {this.state.subdomain && this.state.subdomain != '' ? this.renderFrame2() : this.renderFrame1()}
      </div>
    );
  },



  /**
  * Change handlers
  */

  onBlurUrl: function () {

  },

  onChangeUrl: function (e) {
    this.setState({url: e.target.value});
  },

  onFocusUrl: function () {

  },

  onHideModal: function () {
    $('body').css('overflow', 'auto');
    this.setState({modalVisible: false});
  },

  onSubmit: function (e) {
    e.preventDefault();
    e.stopPropagation();

    var url_regex = /^(?:https*:\/\/)*([a-zA-Z0-9][a-zA-Z0-9-_]*)\.*[a-zA-Z0-9]*[a-zA-Z0-9-_]*glossgenius.com\/*$/igm
    var matches = url_regex.exec(this.state.url);
    console.log('onSubmit!', this.state.url, this.state.url.match(url_regex), matches);
    if (this.state.url.match(url_regex)) {
      this.setState({subdomain: matches[1]})
    } else {
      alert('This does not seem to be a valid SolaGenius website URL.');
    }
  },



  /**
  * Helper functions
  */

  // validSolaGeniusURL: function () {
  //   return false;
  // }

});