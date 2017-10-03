var TestimonialForm = React.createClass({

  getInitialState: function () {
    return {
      testimonial: this.props.testimonial || {}
    };
  },

  render: function () {
    console.log('render TestimonialForm', this.state.testimonial);
    return (
      <div className="testimonial-form">
        <div className="control-group" style={{paddingTop: '0px'}}>
          <label>Name</label>
          <input name="name" value={this.state.testimonial.name} onChange={this.onChange} maxLength="255" type="text" />
        </div>
        <div className="control-group">
          <label>Text</label>
          <textarea name="text" value={this.state.testimonial.text} onChange={this.onChange} rows="5" />
        </div>
        <div className="control-group">
          <label>Region</label>
          <input name="region" value={this.state.testimonial.region} onChange={this.onChange} maxLength="255" type="text" />
        </div>
      </div>
    );
  },

  onChange: function (e) {
    var self = this;
    var testimonial = this.state.testimonial;
    
    testimonial[e.target.name] = e.target.value;
    
    this.setState({testimonial: testimonial}, function () {
      self.props.onChange({
        target: {
          name: self.props.name,
          value: testimonial
        }
      });
    });
  },

});