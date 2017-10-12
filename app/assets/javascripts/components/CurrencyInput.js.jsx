var CurrencyInput = React.createClass({

  componentDidMount: function () {
    this.bindAutoNumeric();
  },

  componentWillReceiveProps: function (nextProps) {
    var self = this;

    if (this.state.value != nextProps.value && typeof nextProps.value != 'undefined') {
      //console.log('CurrencyInput updating yo', this.props.name, nextProps.value);
      if (nextProps.value === null || nextProps.value === '') {
        //console.log('null, set it empty')
        this.setState({value: null}, function () {
          //console.log('CurrencyInput wipe!');
          $(self.refs.textInput).autoNumeric('wipe');
        });
      } else {
        //console.log('CurrencyInput not null', this.props.name, nextProps.value);
        this.setState({value: nextProps.value}, function () {
          $(self.refs.textInput).autoNumeric('set', self.state.value / 100);
        });
      }
    }
  },

  getInitialState: function () {
    return {
      value: this.props.value
    }
  },

  bindAutoNumeric: function () {
    var self = this;
    var $textInput = $(this.refs.textInput);

    if (!isNaN(parseInt(this.state.value))) {
      $textInput.val(this.state.value / 100);
    }

    // bind autoNumeric
    $textInput.autoNumeric({
      aSep: ',',
      aDec: '.'
    }).on('change', function () { self.onInput(); }).on('input', function () { self.onInput(); }).trigger('input').trigger('blur');
  },

  onInput: function () {
    var value = '';
    var inputValue = $(this.refs.textInput).autoNumeric('get');
    
    //console.log('CurrencyInput onInput', this.props.name, inputValue);
    if (!isNaN(inputValue)){
      //console.log('yes isnan', this.props.name);
      if (typeof this.props.min != 'undefined' && inputValue * 100 < this.props.min) {
        //console.log('1!')
        value = inputValue = this.props.min;
        $(this.refs.textInput).autoNumeric('set', inputValue / 100);
      } else if (typeof this.props.max != 'undefined' && inputValue * 100 > this.props.max) {
        //console.log('2!')
        value = inputValue = this.props.max;
        $(this.refs.textInput).autoNumeric('set', inputValue / 100);
      } else if (inputValue != 0) {
        //console.log('3!', inputValue, typeof inputValue);
        value = inputValue * 100;
      } else if (inputValue == 0) {
        value = inputValue;
      } else {
        //console.log('4!', inputValue, typeof inputValue, value);
        value = null;
      }
    } 

    //console.log('currencyInput', value);

    this.setState({value: value}, () => {
      if (this.props.onChange) {
        this.props.onChange({target: {value: value, name: this.props.name}});
      }
    });    
  },

  render: function () {
    return (
      <div className="input-prepend">
        <label className="add-on ui-button ui-widget ui-state-default ui-corner-all ui-button-icon-only" style={{backgroundColor: "#DCE4EC"}}>
          <span style={{display: "inline-block", margin: "0 7px", position: "relative", top: "1px"}}>$</span>
        </label>
        <input type='text' ref='textInput' disabled={this.props.disabled} name={this.props.name + '_masked'} className="currency-input" style={{textAlign: 'left'}} />
        <input type='hidden' ref='hiddenInput' disabled={this.props.disabled} name={this.props.name} value={this.state.value || ''} />
      </div>
    );
  },

  getValue: function () {
    return this.state.value || 0;
  },
  
});