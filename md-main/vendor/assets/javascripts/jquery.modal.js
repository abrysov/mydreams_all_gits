/*                                                                            */
/*   XXXX        XXXX    XXXXXXXX    XXXXXXXXXX       XXXXXX     XXXX         */
/*   XXXXX      XXXXX  XXXXXXXXXXXX  XXXXXXXXXXXX    XXXXXXXX    XXXX         */
/*   XXXXXX    XXXXXX  XXXX    XXXX  XXXX    XXXX   XXXX  XXXX   XXXX         */
/*   XXXXXXX  XXXXXXX  XXXX    XXXX  XXXX    XXXX  XXXX    XXXX  XXXX         */
/*   XXXX XXXXXX XXXX  XXXX    XXXX  XXXX    XXXX  XXXX    XXXX  XXXX         */
/*   XXXX  XXXX  XXXX  XXXX    XXXX  XXXX    XXXX  XXXX    XXXX  XXXX         */
/*   XXXX   XX   XXXX  XXXX    XXXX  XXXX    XXXX  XXXXXXXXXXXX  XXXX         */
/*   XXXX        XXXX  XXXX    XXXX  XXXX    XXXX  XXXXXXXXXXXX  XXXX         */
/*   XXXX        XXXX  XXXXXXXXXXXX  XXXXXXXXXXXX  XXXX    XXXX  XXXXXXXXXX   */
/*   XXXX        XXXX    XXXXXXXX    XXXXXXXXXX    XXXX    XXXX  XXXXXXXXXX   */
/*                                                                            */
/******************************************************************************/

( function( $ ) {

	var count = 0;
	var modals = [];
	var settings = {

		content: null,

		beforeShow: null,
		afterShow: null,
		beforeHide: null,
		afterHide: null

	}
	var methods = {

		init: function( options ) { 

			settings = $.extend( options );

			return this.each( function() {

				var $this = $( this );
				$this.bind( 'click.modal', methods.show );

			});

		},
		destroy: function( ) {

			return this.each( function() {

				$( this ).unbind( '.modal' );

			});

		},
		show: function( settings ) {

			//event.preventDefault();

			if ( typeof settings.beforeShow !== 'undefined' && settings.beforeShow !== null ) settings.beforeShow();

			var $this = $( this );

			var html = $( 'html' );
			var body = $( 'body' );

			var overlay = $( '<div class="modal-overlay" />' );
			var wrapper = $( '<div class="modal-wrapper" />' ).appendTo( overlay );
			var scroller = $( '<div class="modal-scroller" />' ).appendTo( wrapper );
			var close_overlay = $( '<div class="modal-close-overlay" />' ).prependTo( scroller );
			var container = $( '<div class="modal-container" />' ).appendTo( scroller );
			var content = $( '<div class="modal-content"/>' ).appendTo( container );
			
			var close_button = $( '<div class="modal-close-button"/>' ).appendTo( container );

			overlay.css({ 'z-index': 100000, 'position': 'fixed', 'width': '100%', 'height': '100%', 'top': 0, 'right': 0, 'bottom': 0, 'left': 0, 'overflow-y': 'auto', 'overflow-x': 'hidden' });
			wrapper.css({ 'display': 'table', 'border-collapse': 'collapse', 'border-spacing': 0, 'width': '100%', 'height': '100%' });
			scroller.css({ 'position': 'relative', 'display': 'table-cell', 'vertical-align': 'middle', 'height': '100%' });
			container.css({ 'position': 'relative', 'display': 'table', 'border-collapse': 'collapse', 'border-spacing': 0 });
			content.css({ 'position': 'relative', 'display': 'table-cell' });
			close_overlay.css({ 'position': 'absolute', 'left': 0, 'top': 0, 'bottom': 0, 'right': 0, 'cursor': 'pointer' });
			close_button.css({ 'position': 'fixed', 'cursor': 'pointer' });

			var source;
			if ( settings.content === null ) source = $( $this.attr( 'href' ) );
			else source = settings.content;

			source.appendTo( content );

			html.css( 'overflow-y', 'hidden' );
			if ( body.height() > $( window ).height() ) body.css( 'overflow-y', 'scroll' );
			else body.css( 'overflow-y', 'hidden' );

			overlay.css( 'opacity', 0 );
			body.append( overlay );
			count++;

			/* REPOSITION */

			methods.reposition( overlay, wrapper, close_overlay, close_button );

			var iframe = document.createElement( 'iframe' );
			content.append( iframe );
			$( iframe ).css({ position: 'absolute', zIndex: -100, width: '100%', height: '100%', left: 0, top: 0 });
			iframe.contentWindow.onresize = function() {
				methods.reposition( overlay, wrapper, close_overlay, close_button );
			}

			$( window ).bind( 'resize.modal', function() {
				methods.reposition( overlay, wrapper, close_overlay, close_button )
			});

			/* BUTTONS */

			close_button.click( function( event ) {
				methods.hide( overlay, source );
				event.preventDefault();
			});
			close_overlay.click( function( event ) {
				methods.hide( overlay, source );
				event.preventDefault();
			});
			overlay.animate( { opacity: 1 }, 300, function() {
				if ( typeof settings.afterShow !== 'undefined' && settings.afterShow !== null ) settings.afterShow();
			});

		},
		hide: function( overlay ) {

			if ( typeof settings.beforeHide !== 'undefined' && settings.beforeHide !== null ) settings.beforeHide();

			var html = $( 'html' );
			var body = $( 'body' );

			overlay.animate( { opacity: 0 }, 300, function() {
				count--;
				if ( count == 0 ) {
					html.css( 'overflow-y', 'auto' );
					body.css( 'overflow-y', 'auto' );
				}
				overlay.remove();
				if ( typeof settings.afterHide !== 'undefined' && settings.afterHide !== null ) settings.afterHide();
			});

			$( window ).unbind( '.modal' );

		},
		reposition: function( overlay, wrapper, close_overlay, close_button ) { 

			return overlay.each( function() {

				if ( $( 'body' ).height() > $( window ).height() ) $( 'body' ).css( 'overflow-y', 'scroll' );
				else $( 'body' ).css( 'overflow-y', 'hidden' );
				if ( overlay.height() < wrapper.height() ) {
					close_button.css( 'position', 'fixed' ).removeClass( 'absolute' );
				} else {
					close_button.css( 'position', 'absolute' ).addClass( 'absolute' );
				}

			});

		},
		closeAll: function() {
			alert( 'closeAll' );
		},
		closeCurrent: function() {
			alert( 'closeCurrent' );
		}

	};

	$.fn.modal = function( method ) {  

		if ( methods[method] ) {
			return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ) );
		} else if ( typeof method === 'object' || ! method ) {
			return methods.init.apply( this, arguments );
		} else {
			$.error( 'Метод с именем ' +  method + ' не существует для jQuery.modal' );
		}

	};

}) ( jQuery );

/************************************************************************************/
/*                                                                                  */
/*   XXXXXXXXXXXX  XXXXXXXX  XXXX     XXXX  XXXXXXXX    XXXXXXXX    XXXX     XXXX   */
/*   XXXXXXXXXXXX  XXXXXXXX  XXXXX    XXXX  XXXXXXXX  XXXXXXXXXXXX  XXXX     XXXX   */
/*   XXXX            XXXX    XXXXXX   XXXX    XXXX    XXXX    XXXX  XXXX     XXXX   */
/*   XXXX            XXXX    XXXXXXX  XXXX    XXXX    XXXX          XXXX     XXXX   */
/*   XXXXXXXXXX      XXXX    XXXXXXXX XXXX    XXXX    XXXXXXXXXX    XXXXXXXXXXXXX   */
/*   XXXXXXXXXX      XXXX    XXXXXXXXXXXXX    XXXX      XXXXXXXXXX  XXXXXXXXXXXXX   */
/*   XXXX            XXXX    XXXX XXXXXXXX    XXXX            XXXX  XXXX     XXXX   */
/*   XXXX            XXXX    XXXX  XXXXXXX    XXXX    XXXX    XXXX  XXXX     XXXX   */
/*   XXXX          XXXXXXXX  XXXX   XXXXXX  XXXXXXXX  XXXXXXXXXXXX  XXXX     XXXX   */
/*   XXXX          XXXXXXXX  XXXX    XXXXX  XXXXXXXX    XXXXXXXX    XXXX     XXXX   */
/*                                                                                  */