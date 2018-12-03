var BookNowReferral = React.createClass({

  getInitialState: function () {
    return {
      height: 600,
      width: 1200,
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
          <form>
            <div className="col-input">
              <input type="text" className="form-control input-block" value={this.state.url} onChange={this.onChangeUrl} onFocus={this.onFocusUrl} onBlur={this.onBlurUrl} placeholder="website.glossgenius.com" />
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
        <p>Copy the business URL assigned to you through the SolaGenius app and paste it below to receive your referral link.</p>
      </div>
    );
  },

  renderModal: function () {
    return (
      <div className="BookNowModal" style={{width: this.state.width, height: this.state.height, marginLeft: -(this.state.width / 2), marginTop: -(this.state.height / 2)}}>
        <div className="ink-cloud-left"></div>
        <div className="ink-cloud-right"></div>
        <div className="fa fa-times" onClick={this.onHideModal}></div>
        {this.validSolaGeniusURL() ? this.renderFrame2() : this.renderFrame1()}
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



  /**
  * Helper functions
  */

  validSolaGeniusURL: function () {
    return false;
  }

});