var MySolaGallery = React.createClass({

  getInitialState: function () {
    var results_per_page = 8;
    var images = this.props.images ? this.shuffle(JSON.parse(this.props.images)) : [];
    var images_length = images.length;
    var total_pages = images_length / results_per_page + (images_length % results_per_page > 0 ? 1 : 0) - 1;
    total_pages = total_pages < 1 ? 1 : total_pages;
    
    return {
      current_page: 0,
      images: images,
      loading: false,
      results_per_page: results_per_page,
      total_pages: total_pages,
    };
  },

  render: function () {
    //console.log('RENDER --- images.length', this.state.images.length, 'total_pages', this.state.total_pages);

    return (
      <div className="my-sola-image-gallery">
        {this.renderImages()}
        {this.renderLoadMore()}
      </div>
    )
  },

  renderImages: function () {
    var self = this;
    var current_page_of_images = this.state.images.slice(0, (this.state.current_page * this.state.results_per_page) + this.state.results_per_page);
    var images = current_page_of_images.map(function (image, idx) {
      return (
        <div className="image-wrapper" key={image.id} onMouseEnter={self.showOverlay.bind(null, image.id, idx)} onMouseLeave={self.hideOverlay.bind(null, image.id, idx)} onClick={self.toggleOverlay.bind(null, image.id, idx)}>
          <img src={image.generated_image_url} />
          {self.renderImageOverlay(image)}
        </div>
      );
    });

    return (
      <div className="images-wrapper clearfix">{images}</div>
    );
  },

  renderImageOverlay: function (image) {
    if (image && (image.instagram_handle || image.name) && image.overlay) {
      return (
        <a href={"https://www.instagram.com/" + (image.instagram_handle ? image.instagram_handle.substring(1) : '')} target="_blank" className="overlay">
         <div className="handle-wrapper"><div className="handle">{image.instagram_handle || image.name}</div></div>
        </a>
      );
    }
  },

  renderLoadMore: function () {
    if (this.state.total_pages > this.state.current_page + 1) {
      return (
        <div className="text-center load-more-wrapper">
          <button type="button" className="button" onClick={this.nextPage}>LOAD MORE</button>
        </div>
      );
    }
  },

  nextPage: function () {
    this.setState({current_page: this.state.current_page + 1});
  },

  showOverlay: function (id, idx) {
    //console.log('showOverlay', idx, this.state.images[idx]);
    this.state.images[idx].overlay = true;
    this.forceUpdate();
  },

  hideOverlay: function (id, idx) {
    //console.log('hideOverlay', idx, this.state.images[idx]);
    this.state.images[idx].overlay = false;
    this.forceUpdate();
  },

  toggleOverlay: function (id, idx) {
    //console.log('toggleOverlay', idx, this.state.images[idx]);
    if (this.state.images[idx].overlay) {
      this.state.images[idx].overlay = true;
    } else {
      this.state.images[idx].overlay = false;
    }
    
    this.forceUpdate();
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