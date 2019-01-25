var SideTabPopUpModal = React.createClass({

	getInitialState: function () {
		return {
			fullHeight: false,
			fullWidth: false,
		}
	},

	componentDidMount: function () {
		var self = this;
		var $window = $(window);

		// handle SideTabPopUpModal sizing
		$window.on('resize.SideTabPopUpModal', function () {
			var width = $window.width();
			var height = $window.height();
			var fullWidth = width <= 400;
			var fullHeight = height <= 370;

			//console.log('window', width, height, 'SideTabPopUpModal', b_width, b_height);

			if (fullWidth != self.state.fullWidth || fullHeight != self.state.fullHeight) {
				self.setState({fullHeight: fullHeight, fullWidth: fullWidth});
			}
		}).trigger('resize.SideTabPopUpModal');
	},

	componentDidUpdate: function () {
		// disable / enable scrolling
		if (this.props.visible) {
			$('html, body').css({
		    overflow: 'hidden',
		    height: '100%'
			});
		} else {
			$('html, body').css({
		    overflow: 'auto',
		    height: 'auto'
			});
		}
	},



	/*
	* Render
	*/

	render: function () {
		if (this.props.visible) {
			return (
				<div className="SideTabPopUpModalOverlay HideSideTabPopUpModal">
					<div className={"SideTabPopUpModal" + (this.state.fullHeight ? ' FullHeight ' : '') + (this.state.fullWidth ? ' FullWidth ' : '')} ref="SideTabPopUpModal">
						<span className="close-x" onClick={this.props.onHideSideTabPopUpModal}></span>
						<p dangerouslySetInnerHTML={{__html: I18n.t('sola_search.if_you_do_not_see')}}></p>
						<p dangerouslySetInnerHTML={{__html: I18n.t('sola_search.booknow_search_results')}}></p>
						<div className="button-wrapper"><a href="/salon-professionals">{I18n.t('sola_search.contact_your_sola_pro_directly')}</a></div>
					</div>
				</div>
			);
		} else {
			return null;
		}
	}

});