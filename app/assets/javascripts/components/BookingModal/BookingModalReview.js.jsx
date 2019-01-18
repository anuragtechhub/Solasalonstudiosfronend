var BookingModalReview = React.createClass({

	getInitialState: function () {
		return {
			defaultCoverImageUrl: 'https://s3-us-west-2.amazonaws.com/glossgenius-static-v2/user_avatar.jpg',
			useDefaultCoverImage: false,
			height: 'auto',
			width: '110px',
			top: '0',
			left: '0',
		};
	},

	render: function () {
		//console.log('render BookingModalReview', this.props);
		return (
			<div className="BookingModalReview">
				{this.renderHeader()}
				{this.renderBody()}
			</div>
		);
	},

	renderBody: function () {
		return (
			<div className="Body">
				<BookingModalDateRow {...this.props} {...this.state} />
				<BookingModalTimeRow {...this.props} {...this.state} />
				<BookingModalServicesRow {...this.props} {...this.state} />
			</div>
		);
	},

	renderHeader: function () {
		return (
			<div className="Header">
				<div className="ProfessionalCoverImage">
					<a href={'//' + this.props.professional.booking_page_url} target={this.props.professional.booking_page_url} className="ga-et" data-gcategory="BookNow" data-gaction="View SolaGenius Professional Landing Page" data-glabel={this.props.professional.booking_page_url}>
						<img style={{height: this.state.height, width: this.state.width, top: this.state.top, left: this.state.left}} src={this.state.useDefaultCoverImage ? this.state.defaultCoverImageUrl : this.props.professional.cover_image} alt={this.props.professional.full_name} onError={this.onCoverImageError} onLoad={this.onCoverImageLoad} className="ga-et" data-gcategory="BookNow" data-gaction="View SolaGenius Professional Page" data-glabel={this.props.professional.booking_page_url} />
					</a>
					<div className="Gradient"></div>
				</div>
				<div className="ProfessionalInfo">
					<div className="ProfessionalName">{this.props.professional.full_name}</div>
					<div className="ProfessionalAddress">{this.props.professional.business_address}</div>
					<a href={'//' + this.props.professional.booking_page_url + (this.props.professional.booking_page_url.endsWith('/') ? '' : '/') + 'contact'} target={this.props.professional.booking_page_url + 'contact'} className="Contact ga-et" data-gcategory="BookNow" data-gaction="View SolaGenius Professional Contact Page" data-glabel={this.props.professional.booking_page_url + 'contact'}>{I18n.t('sola_search.contact')}&nbsp;{this.props.professional.full_name}</a>
				</div>
			</div>
		);
	},



	/**
	* Change handlers
	*/

	onCoverImageError: function () {
		this.setState({useDefaultCoverImage: true});
	},

	onCoverImageLoad: function (e) {
		var self = this;
		//console.log('onCoverImageLoad', $(e.target).attr('src'));
		//(function () {
		var img = new Image;
		img.src = $(e.target).attr('src');
    img.onload = function() {
    	var image_scale = self.scaleImage(img.width, img.height, 110, 110);
    	//console.log("onCoverImageLoad intrinsic size: " + img.width + "x" + img.height, image_scale);
    	self.setState({top: image_scale.targettop, left: image_scale.targetleft, width: image_scale.width, height: image_scale.height});
    };
		//})();

		// console.log('cover image load!', this.width, this.height, $(e.currentTarget).width(), $(e.currentTarget).width());
	},



	/**
	* Helper functions
	*/

	scaleImage: function (srcwidth, srcheight, targetwidth, targetheight, fLetterBox) {
    var result = { width: 0, height: 0, fScaleToTargetWidth: true };

    if ((srcwidth <= 0) || (srcheight <= 0) || (targetwidth <= 0) || (targetheight <= 0)) {
        return result;
    }

    // scale to the target width
    var scaleX1 = targetwidth;
    var scaleY1 = (srcheight * targetwidth) / srcwidth;

    // scale to the target height
    var scaleX2 = (srcwidth * targetheight) / srcheight;
    var scaleY2 = targetheight;

    // now figure out which one we should use
    var fScaleOnWidth = (scaleX2 > targetwidth);
    if (fScaleOnWidth) {
        fScaleOnWidth = fLetterBox;
    }
    else {
       fScaleOnWidth = !fLetterBox;
    }

    if (fScaleOnWidth) {
        result.width = Math.floor(scaleX1);
        result.height = Math.floor(scaleY1);
        result.fScaleToTargetWidth = true;
    }
    else {
        result.width = Math.floor(scaleX2);
        result.height = Math.floor(scaleY2);
        result.fScaleToTargetWidth = false;
    }
    result.targetleft = Math.floor((targetwidth - result.width) / 2);
    result.targettop = Math.floor((targetheight - result.height) / 2);

    return result;
	}

});