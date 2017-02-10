var MySolaGallery = React.createClass({

  getInitialState: function () {
    return {
      images: this.props.images ? this.shuffle(JSON.parse(this.props.images)) : [],
      loading: false
    };
  },

  render: function () {
    console.log('images', this.state.images);
    return null;
  },

  shuffle: function (array) {
    var counter = array.length;

    // while there are elements in the array
    while (counter > 0) {
      // pick a random index
      var index = Math.floor(Math.random() * counter);

      // decrease counter by 1
      counter--;

      // swap the last element with it
      var temp = array[counter];
      array[counter] = array[index];
      array[index] = temp;
    }

    return array;
  },

});