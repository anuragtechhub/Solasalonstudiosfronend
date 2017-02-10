var MySolaGallery = React.createClass({

  getInitialState: function () {
    var images = this.props.images ? this.shuffle(JSON.parse(this.props.images)) : [];
    var images_length = images.length;
    var total_pages = images_length / 12 + (images_length % 12 > 0 ? 1 : 0) - 1;
    total_pages = total_pages < 1 ? 1 : total_pages;
    
    return {
      current_page: 0,
      images: images,
      loading: false,
      results_per_page: 12,
      total_pages: total_pages,
    };
  },

  render: function () {
    console.log('images.length', this.state.images.length, 'total_pages', this.state.total_pages);
    var current_page_of_images = this.state.images.slice(this.state.current_page * this.state.results_per_page, (this.state.current_page * this.state.results_per_page) + this.state.results_per_page);
    var images = current_page_of_images.map(function (image) {
      return (
        <div className="image-wrapper" key={image.id}>
          <img src={image.generated_image_url} />
        </div>
      );
    });

    return (
      <div className="my-sola-image-gallery">
        {images}
      </div>
    )
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