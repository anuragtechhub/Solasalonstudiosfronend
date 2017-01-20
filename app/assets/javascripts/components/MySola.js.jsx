var MySola = React.createClass({

  render: function () {
    return (
      <div className="my-sola">
        <div className="container">
          {this.renderHeaderCopy()}
        </div>
        <Dropzone />
      </div>
    );
  },

  renderHeaderCopy: function () {
    return (
      <div className="header-copy">
        <div className="overview">Overview:</div>
        <h2>What does your Sola mean to you?</h2>
        <p>Upload a photo and fill in one of the two statements below to create a custom image. Share your pic and tell the world why you decided to go Sola.</p>
      </div>
    );
  },

});