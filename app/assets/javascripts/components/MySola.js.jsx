var MySola = React.createClass({

  getInitialState: function () {
    return {
      handle: '',
      i_feel: '',
      my_sola_is_my: '',
      name: '',
      scrollTop: 0,
      sharePopupVisible: false,
      fileUploadOverlay: false,
    };
  },

  componentDidMount: function () {
    var self = this;

    // window scroll handler
    $(window).on('scroll', function () {
      self.setState({scrollTop: $(window).scrollTop()});
    }).trigger('scroll');

    // hide social sharing popup
    window.onClickSocialShareButton = function () {
      self.onHideSocialSharePopup();
    },

    // social sharing
    $(this.refs.social_share_wrapper).jsSocials({
      shares: ["twitter", "facebook"],
      text: self.shareText(),
      showCount: false,
      showLabel: false,
      shareIn: 'popup',
    });
  },

  componentDidUpdate: function () {
  
  },

  shareText: function () {
    if (this.state.i_feel) {
      return "I feel " + this.state.i_feel + ' in #MySola';
    } else if (this.state.my_sola_is_my) {
      return "#MySola is my " + this.state.my_sola_is_my;
    }
  },

  render: function () {
    return (
      <div className="my-sola">
        <div className="container">
          {this.renderHeaderCopy()}
          {this.renderNameAndHandleForm()}
          <ImageDropzone />
          {this.renderStatementForm()}
          {this.renderBottomButtons()}
        </div>
        {this.state.scrollTop > 0 ? <div className="back-to-top" onClick={this.onScrollToTop}></div> : null}
      </div>
    );
  },

  renderBottomButtons: function () {
    return (
      <div className="bottom-buttons">
        <div className="share-button">
          <a href="#" className="button block" onClick={this.onToggleSharePopup}>Share</a>
          <div className="social-share-icons" ref="social_share_wrapper" style={{display: this.state.sharePopupVisible ? 'block' : 'none'}}></div>
        </div>
        <a href="#" className="button block">Download</a>
        <div className="start-over"><a href="#" onClick={this.onStartOver}>Start Over</a></div>
      </div>
    );
  },

  renderHeaderCopy: function () {
    return (
      <div className="header-copy">
        <h3>Overview:</h3>
        <h2>What does your Sola mean to you?</h2>
        <p>Upload a photo and fill in one of the two statements below to create a custom image. Share your pic and tell the world why you decided to go Sola.</p>
      </div>
    );
  },

  renderNameAndHandleForm: function () {
    return (
      <div className="name-and-handle-form">
        <input type="text" name="name" placeholder="Please enter your name" value={this.state.name} onChange={this.onChangeTextInput} />
        <input type="text" name="handle" placeholder="Please enter your Instagram handle" value={this.state.handle} onChange={this.onChangeTextInput} />
        <div className="next">
          <h3>Next</h3>
          <div className="next-icon"></div>
        </div>
      </div>
    );
  },

  renderStatementForm: function () {
    return (
      <div className="statement-form">
        <h3>Choose a statement below:</h3>
        <div className="madlibs">#MySola is my <input type="text" name="my_sola_is_my" placeholder='Type your "expression" here' maxLength="21" value={this.state.my_sola_is_my} onChange={this.onChangeTextInput} onKeyDown={this.onKeyDownMadLibsInput} /></div>
        <h3>Or:</h3>
        <div className="madlibs">I feel <input type="text" name="i_feel" placeholder='Type your "expression" here' maxLength="21" value={this.state.i_feel} onChange={this.onChangeTextInput} onKeyDown={this.onKeyDownMadLibsInput} /> in #MySola</div>
      </div>
    );
  },

  onChangeTextInput: function (event) {
    var state = this.state;
    state[event.target.name] = event.target.value;
    this.setState(state);
  },

  onHideSocialSharePopup: function () {
    this.setState({sharePopupVisible: false});
    $(window).off('click.share');
  },

  onKeyDownMadLibsInput: function (event) {
    if (event.target.name == 'my_sola_is_my') {
      this.setState({i_feel: ''});
    } else if (event.target.name == 'i_feel') {
      this.setState({my_sola_is_my: ''});
    }
  },

  onScrollToTop: function (event) {
    if (event && typeof event.preventDefault == 'function') {
      event.preventDefault();
    }

    $("html, body").animate({scrollTop: 0}, "normal");
  },

  onStartOver: function (event) {
    var self = this;

    if (event && typeof event.preventDefault == 'function') {
      event.preventDefault();
    }

    this.setState(this.getInitialState(), function () {
      self.onScrollToTop();
    });
  },

  onToggleSharePopup: function (event) {
    var self = this;

    event.preventDefault();    
    event.stopPropagation();

    if (this.state.sharePopupVisible) {
      this.onHideSocialSharePopup();
    } else {
      this.setState({sharePopupVisible: true});
      $(window).on('click.share', function () {
        self.onHideSocialSharePopup();
      });
    }
  },

});