var MySola = React.createClass({

  getInitialState: function () {
    return {
      my_sola_is_my: '',
      i_feel: ''
    };
  },

  render: function () {
    return (
      <div className="my-sola">
        <div className="container">
          {this.renderHeaderCopy()}
          <Dropzone />
          {this.renderStatementForm()}
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

  renderStatementForm: function () {
    return (
      <div className="statement-form">
        <h3>Choose a statement below:</h3>
        <div className="madlibs">#MySola is my <input type="text" name="my_sola_is_my" placeholder='Type your "expression" here' maxLength="21" value={this.state.my_sola_is_my} onChange={this.onChangeMadLibsInput} onKeyDown={this.onKeyDownMadLibsInput} /></div>
        <h3>Or:</h3>
        <div className="madlibs">I feel <input type="text" name="i_feel" placeholder='Type your "expression" here' maxLength="21" value={this.state.i_feel} onChange={this.onChangeMadLibsInput} onKeyDown={this.onKeyDownMadLibsInput} /> in #MySola</div>
      </div>
    );
  },

  onChangeMadLibsInput: function (event) {
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

});