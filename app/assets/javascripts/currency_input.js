$.widget('solasalonstudios.currencyinput', {
  
  _create: function() {
    var self = this;

    // build elements
    var $add_on_label = $('<label class="add-on ui-button ui-widget ui-state-default ui-corner-all ui-button-icon-only" style="background-color:#DCE4EC"></label>');
    var $dollar_sign = $('<span style="display:inline-block;margin:0 7px;position:relative;top:1px;">$</span>');
    self.$input = $('<input type="text" name="' + self.element.attr('name') + '_input' + '" value="' + (self.element.val() ? self.element.val() / 100 : '') + '" class="currency-input" />');
    
    // append to DOM
    self.element.wrap('<div class="input-prepend"></div>');
    $add_on_label.append($dollar_sign);
    self.element.before($add_on_label).before(self.$input);

    // bind autonumeric
    self.$input.autoNumeric({
      aSep: ',',
      aDec: '.'
    }).on('change', function () { self.onInput(); }).on('input', function () { self.onInput(); }).trigger('input').trigger('blur');     
  },

  onInput: function () {
    var self = this;
    var value = '';
    var inputValue = this.$input.autoNumeric('get');
    
    if (!isNaN(inputValue)) {
      self.element.val(inputValue * 100);
    }
  },

});