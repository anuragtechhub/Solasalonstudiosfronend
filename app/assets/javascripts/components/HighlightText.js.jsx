var HighlightText = React.createClass({

  render: function () {
    if (this.props.words && this.props.words.length && this.props.words[0] != '') {
      var tag = 'strong';
      var words = this.props.words;
      var regex = RegExp(words.join('|'), 'gi') // case insensitive
      var replacement = '<'+ tag +'>$&</'+ tag +'>';
      var kids = typeof this.props.children.join == 'function' ? this.props.children.join('') : this.props.children;

      return <span dangerouslySetInnerHTML={{__html: kids.replace(regex, replacement)}}></span>
    } else {
      return <span>{this.props.children}</span>
    }
  },

});