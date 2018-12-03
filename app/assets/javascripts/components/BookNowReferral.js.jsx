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
      } else {
        self.setState({width: 1200});
      }

      if (window_height <= 600) {
        self.setState({height: window_height});
      } else {
        self.setState({height: 600});
      }
    }).trigger('resize');
  },

  componentDidUpdate: function () {
    if (this.refs.socialShareIcons) {
      $(this.refs.socialShareIcons).jsSocials({
        url: 'https://glossgenius.com/invite/' + this.state.subdomain,
        text: 'Run your buiness like a boss! Check out SolaGenius.',
        showLabel: false,
        showCount: false,
        shares: ["facebook", "twitter", "email"]
      });
    }
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
              <input type="text" className="form-control input-block" ref="input" value={this.state.url} onChange={this.onChangeUrl} onFocus={this.onFocusUrl} onBlur={this.onBlurUrl} />
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
              <input type="text" className="form-control input-block" ref="invite" id="referral-invite" value={'https://glossgenius.com/invite/' + this.state.subdomain} />
            </div>
            <div className="col-button">
              <button type="submit" className="btn" id="copy-link" data-clipboard-target="#referral-invite">Copy Link</button>
            </div>
          </form>
        </div>
        <div className="clearfix" style={{height: 1, lineHeight: 1}}>&nbsp;</div>
        <div className="social">
          <h3>Or invite a friend here:</h3>
          <div ref="socialShareIcons"></div>
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

  onCopy: function (e) {
    e.preventDefault();
    e.stopPropagation();
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
    var self = this;

    e.preventDefault();
    e.stopPropagation();

    var url_regex = /^(?:https*:\/\/)*([a-zA-Z0-9][a-zA-Z0-9-_]*)\.*[a-zA-Z0-9]*[a-zA-Z0-9-_]*glossgenius.com\/*$/igm
    var matches = url_regex.exec(this.state.url);
    //console.log('onSubmit!', this.state.url, this.state.url.match(url_regex), matches);
    if (this.state.url.match(url_regex)) {
      this.setState({subdomain: matches[1]}, function () {
        new ClipboardJS('#copy-link');
        if (this.refs.invite) {
          $(this.refs.invite).tooltip({
            title: 'Woo hoo! Your link is ready!',
            trigger: 'manual',
            placement: 'top'
          });
          $(this.refs.invite).tooltip('show');
          setTimeout(function () {
            $(self.refs.invite).tooltip('hide');
            $(self.refs.invite).tooltip('dispose');
          }, 3000);
        }
      });
    } else {
      if (this.refs.input) {
        $(this.refs.input).tooltip({
          title: 'This does not seem to be a valid SolaGenius website URL.',
          trigger: 'manual',
          placement: 'top'
        });
        $(this.refs.input).tooltip('show');
        setTimeout(function () {
          $(self.refs.input).tooltip('hide');
          $(self.refs.input).tooltip('dispose');
        }, 3000);
      }
    }
  },



  /**
  * Helper functions
  */

  // validSolaGeniusURL: function () {
  //   return false;
  // }

});