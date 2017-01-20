var MySola = React.createClass({

  getInitialState: function () {
    return {
      name: '',
      handle: '',
      my_sola_is_my: '',
      i_feel: '',
    };
  },

  render: function () {
    return (
      <div className="my-sola">
        <div className="container">
          {this.renderHeaderCopy()}
          {this.renderNameAndHandleForm()}
          <Dropzone />
          {this.renderStatementForm()}
          <div className="start-over"><a href="#" onClick={this.onStartOver}>Start Over</a></div>
        </div>
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

  onKeyDownMadLibsInput: function (event) {
    if (event.target.name == 'my_sola_is_my') {
      this.setState({i_feel: ''});
    } else if (event.target.name == 'i_feel') {
      this.setState({my_sola_is_my: ''});
    }
  },

  onStartOver: function (event) {
    if (event && typeof event.preventDefault == 'function') {
      event.preventDefault();
    }

    this.setState(this.getInitialState());
  },

});