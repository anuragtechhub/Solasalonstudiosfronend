var RichTextEditor = React.createClass({

  componentDidMount: function () {
    var self = this;

    if (this.refs.textarea) {
      var editor = CKEDITOR.replace(this.refs.textarea, {
        toolbarGroups: [

          { name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ] },
                    { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
        ],
        removeButtons: 'JustifyLeft,JustifyRight,JustifyCenter,JustifyBlock,TextColor,BGColor,FontSize,Font,CreateDiv,Flash,Subscript,Superscript,Scayt,Link,Image,Maximize,Source,Undo,Cut,Copy,Redo,Paste,PasteText,PasteFromWord,Unlink,Anchor,Table,SpecialChar,HorizontalRule,Styles,Format,About,Outdent,Indent,Blockquote',
        removePlugins: 'elementspath',
        resize_enabled: false,
        uiColor: '#FFFFFF',
      });

      editor.on('change', function () {
        self.props.onChange({
          target: {
            name: self.props.name,
            value: editor.getData()
          }
        });
      });
    }
  },

  render: function () {
    return <textarea name={this.props.name} ref="textarea" />
  },

});