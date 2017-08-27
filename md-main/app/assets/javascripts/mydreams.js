$(function(){

  var feedState = 'opened';

  function jmodInit()
  {
    var jmod_btn = $('.jmod-btn').not('jMod');

    jmod_btn.each(function(){
      switch($(this).data('modal-type')){
        case 'authorization':
          $(this).jMod({
            ajaxSuccess: function(link, modal){
              modal.find('.jmod-btn').jMod();
            }
          });
          break;
        default:
          $(this).jMod();
          break;
      }
    });
  };


  var statuses = {

    init: function ()
    {
      var
      that = this,
      inspet_field;

      this.status_form = $('.js-status-form');
      this.status_form_textarea = this.status_form.find('textarea');
      this.status_link = $('.js-status');
      this.default_placeholder = this.status_link.data('defaultPlaceholder');

      this.status_form_textarea.on('focusin', function(e){
        inspet_field = setInterval(function (){
          if (!that.status_form_textarea.val()) {
            that.status_form_textarea.attr('placeholder', that.default_placeholder);
          };
        }, 500);
      });

      this.status_form_textarea.on('focusout', function(e){
        clearInterval(inspet_field);
      });

      $(document).on('click', '.js-status-btn', function(){
        $.post(that.status_form.attr('action'), that.status_form.serialize());
      });
    }
  };


  var user_menu = {

    menu: null,

    init: function(elem)
    {
      this.menu = $(elem);

      var that = this;

      $(document).on('click', '.js-user-menu', function(){

        var btn = $(this);

        if (btn.hasClass('active')) {
          return false;
        }else {
          $(elem).fadeIn(200);
          $(this).addClass('active');

          $(document).one('click', function(){
            $(elem).fadeOut(200);
            btn.removeClass('active');
          });
        }
      });
    }
  };


  // var search = {

  //   init: function()
  //   {
  //     var
  //     that = this,
  //     search_container = $('.js-card-group');


  //     $(document).on('click', '.js-search-tab', function(){
  //       var
  //       target = $(this).data('target'),
  //       target_search_container = $('.js-card-group[data-target='+ target +']');

  //       $(this).addClass('active').siblings().removeClass('active');

  //       target_search_container.find('.js-flip .card__wrap').addClass('flip');
  //       target_search_container.addClass('active').siblings().removeClass('active');

  //       flip.init();
  //     });

  //     for (var i = 0; i < search_container.length; i++) {
  //       var
  //       results = $(search_container[i]).find('.js-flip');

  //       if (results.length) {
  //         $('.js-search-tab[data-target='+ $(search_container[i]).data('target') +']').addClass('active');
  //         $(search_container[i]).addClass('active');

  //         return;
  //       };
  //     };
  //   }
  // }


  function addMark()
  {
    var status_default_text = "My Dreams";

    $(document).on('click', '.js-add-mark', function(){
      var
      container = $('.js-form-container.active'),
      input = container.find('.js-checked-mark-input'),
      checked_mark = container.find('.js-checked-mark'),
      status = container.find('.js-dream-status'),
      type = $(this).attr('data-dream-type');

      input
      .val($(this).data('certificate-id'))
      .attr('data-dream-type', type);

      status.attr('data-dream-type', type).find('.label').html( type );

      checked_mark.attr('data-dream-type', type);

      //если форма "подарить мечту", нужно переключить кнопки
      checkPaymentBtn(container);

      $(document).one('click', '.js-mark-delete', function(){
        input
        .val('')
        .attr('data-dream-type', '');

        input.removeAttr('data-dream-type');

        status.removeAttr('data-dream-type').find('.label').html( status_default_text );

        checked_mark.removeAttr('data-dream-type');

        //если форма "подарить мечту", нужно переключить кнопки
        checkPaymentBtn(container)
      });
    });

    function checkPaymentBtn(container){
      if (container.data('form') == 'add_dream') {
        var
        payment_btns = container.find('.js-create-dream-submit'),
        validation_fields = container.find('.js-validation');

        payment_btns.toggleClass('js-form-submit');

        if (! validation_fields.hasClass('error') && validation_fields.val() != '') {
          container.find('.js-create-dream-submit').addClass('disabled');
          container.find('.js-form-submit').removeClass('disabled');
        };
      };
    }
  }


  function userRandomize()
  {
    $(window).on('load', function(){
      initCoverImages();
      $('.js-wellcome-user').each(function(){
        
        var time = Math.floor( Math.random() * 700 ) + 50; 
        var $this = $( this );
        $this.css({ opacity: 0 });
        $this.animate({scale: "0.1"}, 0 );
        
        setTimeout( function() {

          $this.animate({scale: "1.0", opacity: 0.9}, 500 );

        }, time );
        
        //( "scale", {percent: 1, direction: 'both'}, 0 );
        //$(this).show( "scale", {percent: 100, direction: 'both'}, 1000 );
        // $(this).toggle({ e"scale", 1, 2000 });
        // $(this).animate(
        //   {
        //     width: width,
        //     height: height
        //   },
        // 3000);
      });
    });
  }


  function subPageToggler()
  {
    var toggler = $('.js-sub-toggler');
    
    $(document).off('click', '.js-sub-toggler').on('click', '.js-sub-toggler', function(){

      if(! $(this).hasClass('active')){
        toggler.toggleClass('active');
        
        $('.js-sub-container').siblings('.js-sub-container').fadeOut(400, function(){
          $(this).removeClass('active');
        
          target_form.fadeIn(400, function(){
            $(this).addClass('active');
          });
        });
      }
    });
  }


  function showPageToggler()
  {
    $(document).off('click', '.js-container-show-btn').on('click', '.js-container-show-btn', function(){
      var
      btn_type = $(this).data('container'),
      target_container = $('.js-container-show[data-container="'+ btn_type +'"]'),
      target_container_parent = target_container.closest('.js-containers');

      if (btn_type == 'edit') {

        $('.js-controls').addClass('locked');

      } else {

        $('.js-controls').removeClass('locked');

      }

      if (! $(this).hasClass('active')) {

        $('.js-container-show-btn').removeClass('active').filter('[data-container="'+ btn_type +'"]').addClass('active');

        target_container_parent.css({ 'height': target_container_parent.find('.active').height(), 'oveflow': 'hidden' });

        target_container_parent.find('.active').animate({opacity: 0}, 400, function(){

          $( this ).removeAttr('style');

          target_container.addClass('active').css('opacity', 0 );

          $(this).removeClass('active');

          initAutoheightTextarea();

          target_container_parent.animate({ 'height': target_container.height() }, 400, function() {

            formInit();

            target_container.animate({'opacity': 1}, 400, function() {

              target_container.removeAttr('style');

              target_container_parent.removeAttr('style');
            });
          });
        });
      };

      function formInit()
      {
        if (! target_container.hasClass('imageLoader') && target_container.data('container') == 'edit') {
          target_container.addClass('imageLoader');

          target_container.find('.js-imageLoader').imageLoader();

          target_container.find('.js-edit-form').off('ajax:success').on('ajax:success', function(e, data){
            var
            diff = $.parseJSON(data),
            node = $('.js-edit-node');

            for(k in diff){
              if (k == 'photo') {
                var img = new Image();

                img.setAttribute('src', diff[k][1]['photo']['url'] + '?random');
                node.filter('[data-node="'+ k +'"]').html(img);
              }else {
                node.filter('[data-node="'+ k +'"]').html(diff[k][1]);
              }
            }

            $(this).find('.js-container-show-btn').trigger('click');
          });
        };
      }
    });
  };


  /* FEED */
  function feedShow ()
  {

    var feed_btn = $('.js-feedlink-item');
    var feed = $('.js-feed');

    resumeState();
    if ( feedState == 'opened' ) {
      feed.slideDown(1);
      feed.css( 'display', 'block' );
      feed.addClass( 'opened' );
      feed_btn.each( function() {
        if ( $( this ).is( ':last-child' ) ) {
          $( this ).addClass( 'active' );
        } else {
          $( this ).removeClass( 'active' );
        }
      });
      if ( !supportsLocalStorage() ) {
        localStorage[ "mydreams.feedState" ] = "opened";
      }
    } else {
      feed.slideUp(1);
      feed.css( 'display', 'none' );
      feed.removeClass( 'opened' );
      feed_btn.each( function() {
        if ( !$( this ).is( ':last-child' ) ) {
          $( this ).addClass( 'active' );
        } else {
          $( this ).removeClass( 'active' );
        }
      });
      if ( !supportsLocalStorage() ) {
        localStorage[ "mydreams.feedState" ] = "closed";
      }
    }

    $(document).off('click', '.js-feedlink').on('click', '.js-feedlink', function(){
      var now = new Date()
      var time = now.getTime();
      if ( feedState == 'opened' ) {
        feed.slideUp(300);
        feed.removeClass( 'opened' );
        feed_btn.toggleClass('active');
        feedState = 'closed';
        localStorage[ "mydreams.feedState" ] = "closed";
        localStorage[ "mydreams.lastVisit" ] = time;
      } else {
        feedOverflow();
        feed.addClass( 'opened' );
        feed.slideDown(300);
        feed_btn.toggleClass('active');
        feedState = 'opened';
        localStorage[ "mydreams.feedState" ] = "opened";
        localStorage[ "mydreams.lastVisit" ] = time;
      }
    });

    function resumeState()
    {
      if ( !supportsLocalStorage() ) return false;
      var now = new Date()
      var time = now.getTime();
      var d = time - localStorage[ "mydreams.lastVisit" ]
      if ( d > 86400000 ) localStorage.clear();
      if ( typeof localStorage[ "mydreams.feedState" ] === 'undefined' ) {
        localStorage[ "mydreams.feedState" ] = "opened";
        localStorage[ "mydreams.lastVisit" ] = time;
        feedState = localStorage[ "mydreams.feedState" ];
      } else {
        localStorage[ "mydreams.lastVisit" ] = time;
        feedState = localStorage[ "mydreams.feedState" ];
      }
      return true;
    }

    function supportsLocalStorage()
    {
      // Обязательно добавить обработку переполнения хранилища
      try {
        return ( 'localStorage' in window ) && window[ 'localStorage' ] !== null;
      } catch ( e ) {
        return false;
      }
    }
  };


  function tooltipsInit()
  {
    $('.js-tooltipster').not('.tooltipstered').createTooltip({
      functionBefore: function(origin, continueTooltip){
        continueTooltip();

        var
        tooltip = $('.tooltipster-base'),
        tooltip_link = tooltip.find('.jmod-btn');

        tooltip_link.replaceWith('<div class="jmod-btn-trigger">'+tooltip_link.text()+'</div>');

        $(document).off('click', '.jmod-btn-trigger').on('click', '.jmod-btn-trigger', function(){
          origin.find('.jmod-btn').trigger('click');
        });
      }
    });
  };


  function feedOverflow() {
    var container = $( '.feed_content' );
    var content = $( '.feed_wrapper' );
    var items = $( '.feed__item' );
    container.width( 0 );
    container.width( container.parent().width() );
    setTimeout( function() {
      i = 1;
      items.removeClass( 'hidden' );
      feedCount();
      // WARN: при скейле изображение смещается на 0.5px - получается эффект подергивания. 
      // Нет необходимости выравнивать изображение в ленте. Изображение одного формата с родителем и хорошо ресайзиться.
      // items.filter(":not(.hidden)").each( function() {
      //   fitCoverImages( $( this ).find( 'img' ) );
      // });
    }, 50 );
    function feedCount() {
      if ( container.width() < content.width() ) {
        items.eq( items.length - i ).addClass( 'hidden' );
        i++;
        feedCount();
      } else return;
    }
    $( window ).resize( function() {
      container.width( 0 );
      container.width( container.parent().width() );
      i = 1;
      items.removeClass( 'hidden' );
      feedCount();
      items.filter(":not(.hidden)").each( function() {
        fitCoverImages( $( this ).find( 'img' ) );
      });
    });
  };


  function btn_back (argument) {
    $('.js-back').on('click', function(){
      window.history.go(-1);
    });
  };

  // TODO: fix
  // function scaleCard ()
  // {
  //   var tooltip_show;

  //   $('.js-card-hover')
  //     .on('mouseenter', function(e){
  //       var
  //       that = $(this);

  //       if (!that.hasClass('card-scale')) {
  //         console.log('has class');
  //         that.addClass('card-scale');
  //       };
  //     })
  //     .on('mouseleave', function(e){
  //       var
  //       that = $(this);
  //       tooltip = $('.tooltipster-base');

  //       if(tooltip.length){
  //         tooltip.on('mouseleave', function(){
  //           that.removeClass('card-scale');
  //         });
  //       }else {
  //         that.removeClass('card-scale');
  //       }
  //     });
  // }


  function initCoverImages() {

    var fitted_images = $( '.cover' );

    if ( fitted_images.length > 0 ) {

      fitted_images.each( function() {
        var image = $( this );
        image.ready( function() {
          fitCoverImages( image );
        });
      });
      setTimeout( function() {
        fitted_images.each( function() {
          var image = $( this );
          fitCoverImages( image );
        });
      }, 100 );

      $( window ).resize( function() {
        fitted_images.each( function() {
          var image = $( this );
          image.load( function() {
            fitCoverImages( image );
          });
          setTimeout( function() {
            fitCoverImages( image );
          }, 100 );
        });
      });
    }
  };


  function fitCoverImages( img ) {

    img.removeAttr( 'style' );

    var
    parent = img.parent(),
    iw = img.width(),
    ih = img.height(),
    pw = parent.width(),
    ph = parent.height(),
    k = ph / ih,
    newiw = iw * k;

    if ( newiw >= pw ) {
      img.css({ position: 'absolute', width: 'auto', height: ph, left: ( pw - newiw ) / 2 });
    } else {
      k = pw / iw;
      var newih = ih * k;
      img.css({ position: 'absolute', height: 'auto', width: pw, top: ( ph - newih ) / 2 });
    }
  };


  function initDots() {
    $( '.message-wrapper' ).dotdotdot();
  };


  function initSlider() {
    //alert( $(".js-slider").length );
    $(".js-slider").click( function(event) {
      event.preventDefault();
    });
    $(".js-slider").magnificPopup({
      delegate: 'a',
      type: 'image'
    });
  };


  function initAutoheightTextarea() {

    var elements = $( ".autoheight" );
    if ( elements.length > 0 ) {
      elements.each( function() {
        var textarea = $( this );
        var status_backup = textarea.val();
        var reset_button = textarea.parent().find( '.js-status-reset' );
        var save_button = textarea.parent().find( '.js-status-btn' );
        setTextareaHeight( textarea );
        textarea.on( "input", function() {
          save_button.removeClass( 'disabled' );
          if ( textarea.val() != status_backup ) {
            reset_button.removeClass( 'disabled' );
            save_button.removeClass( 'disabled' );
          } else {
            reset_button.addClass( 'disabled' );
            save_button.addClass( 'disabled' );
          }
          setTextareaHeight( $( this ) );
        });
        textarea.focusout( function() {
          if ( textarea.val() != status_backup ) {
            reset_button.removeClass( 'disabled' );
            save_button.removeClass( 'disabled' );
          } else {
            reset_button.addClass( 'disabled' );
            save_button.addClass( 'disabled' );
          }
        });
        reset_button.click( function() {
          textarea.val( status_backup );
          setTextareaHeight( textarea );
          reset_button.addClass( 'disabled' );
          save_button.addClass( 'disabled' );
        });
        save_button.click( function() {
          save_button.addClass( 'disabled' );
          reset_button.addClass( 'disabled' );
          status_backup = textarea.val();
        });
      });
    }
    function setTextareaHeight( object ) {
      object.css( 'height', 0 );
      var scrollTop = object.scrollTop();
      object.scrollTop( 1000 );
      var newHeight = object.innerHeight() + object.scrollTop();
      object.css( 'height', newHeight ).scrollTop( scrollTop );
    }
  };


  function searchUPdContent()
  {
    //Показать все предложенные
    $(document).off('ajax:success', '.js-show-all').on('ajax:success', '.js-show-all', function(e, data){
      if ($(this).data('append')) {
        $('.js-received-cards').append(data);
        $(this).remove();
      }else {
        $('.js-received-cards').html(data);
      }
      
      _updSuccess(data);      
    });

    //Строка поиска
    $(document).off('click', '.js-fast-search-btn').on('click', '.js-fast-search-btn', function(e){
      e.preventDefault();

      var 
      form = $(this).closest('form.js-fast-search'); 
      url = form.attr('action');

      $.get(url, form.serialize(), function(data){        
        $('.js-search-content').html(data);

        _updSuccess(data);
      });
    });


    //Сортировки
    $('.js-link-search-filter').off('ajax:success').on('ajax:success', function(e, data){
      $('.js-card-group').html(data);
      
      $(this).closest('.js-content-tabs').find('.js-link-search-filter').removeClass('active');
      $(this).addClass('active');

      _updSuccess(data);
    });


    //Подгрузка контента
    $(document).off('click', '#pagination_link').on('click', '#pagination_link', function(e){
      e.preventDefault();

      var 
      $link = $(this),
      next_page = parseInt($link.data('current-page')) + 1,
      total_pages = parseInt($link.data('total-pages')),
      url = $link.attr('href').replace(/(\&|\?)page\=\d+/, '$1page='+ next_page);

      $link.addClass('loading');
      
      $.get(url, {paginator: true}, function(data){
        $link.removeClass('loading');

        $('.js-card-group').append(data);

        $link.remove();

        _updSuccess(data);
      });
    });

    function _updSuccess(data){
      $('.js-tooltipster').not('.tooltipstered').createTooltip();
      
      FlipCard.init();

      jmodInit();

      window.history.pushState(document.location.hostname, "Title", $('#filter_url').val());
    }
  };


  var initPhotoSlider = {
    
    overlay: null,
    
    container: null,
    
    close: null,

    fotorama: null,

    init: function()
    {
      var that = this;
      
      that.photoslider = $( '<div id="photoslider" />' );
      that.photoslider.attr({ 'data-auto': 'false' });

      $('body').append( that.photoslider );

      $(document).off('click', '.fotorama-close').on('click', '.fotorama-close', function(e){
        that._closePhotoModal();
      });
      
      $(document).off('click', '#fotorama-overlay').on('click', '.fotorama-close', function(e){
        that._closePhotoModal();
      });

      $('.js-open-photoslideshow').off('ajax:success').on('ajax:success', function(e, data) {
        
        if ( $( '.flybook' ).hasClass( 'owner' ) ) {  
          for ( var i = 0; i < data.length; i++ ) {

            data[i]['caption'] = '<a href="' + data[i]['del_link'] + '" class="js-delete">Удалить</a>';

          }
        }
        
        that.photoslider.fotorama({

           data: data,
           width: '100%',
           height: '100%',
           nav: 'thumbs',
           allowfullscreen: 'native',
           navposition: 'top',
           thumbwidth: 90,
           thumbheight: 90,
           thumbmargin: 30,
           thumbborderwidth: 0,
           click: true,
           swipe: true,
           arrows: 'always',
           fit: 'scaledown'

        });

        that.fotorama = that.photoslider.data( 'fotorama' );

        that.photoslider.addClass( 'locked' );

        that._openPhotoModal( $( this ) );        

        $( document ).on( 'click', '.js-delete', function( e ) {

          e.preventDefault();
          var url = $( this ).attr( 'href' );
          var index = parseInt( $( this ).attr( 'index' ) );


          $.ajax({

            url: url,
            method: 'DELETE',
            success: function( A ) {

              if ( A ) {

                var index = that.fotorama.activeIndex;
                that.fotorama.splice( index,1 );
                data.splice( index,1 );
                if ( data.length > 0 ) {

                  $( '.all_photos_link' ).html( 'Смотреть все фото (' + data.length + ')' );

                } else {

                  $( '.all_photos_link' ).remove();
                  
                }
                if ( index < 4 ) {
                  
                  var imgs = $( '.js-open-photoslideshow' ).find( 'img' );
                  
                  for (var i = 0; i < 4; i++ ) {

                    if ( i < data.length ) {

                      imgs.eq( i ).attr( 'src', data[ i ]['thumb'] );

                    } else {

                      imgs.eq( i ).remove();

                    }

                  }

                }

                if ( data.length == 0 ) that._closePhotoModal();

              } else {

                alert( 'Ошибка AJAX');

              }

            }

          });

        });
        that.photoslider.on('fotorama:fullscreenexit ', function() {

          $( '#photoslider' ).appendTo( $( '.fotorama-content' ) );

        });

      });
    },

    _openPhotoModal: function(origin)
    {
      
      var 
      that = this,
      index = origin.hasClass('all_photos_link') ? 0 : origin.index();

      that.overlay = $( '<div class="fotorama-overlay" />' );
      that.overlay.html( '<div class="fotorama-wrapper"><div class="fotorama-scroller"><div id="fotorama-overlay"></div><div class="fotorama-container"></div></div></div>' );
      that.container = that.overlay.find( '.fotorama-container' );
      that.content = $( '<div class="fotorama-content"/>' ).appendTo( that.container );
      that.close = $( '<button class="fotorama-close"/>' ).appendTo( that.container );

      that.content.append( that.photoslider );
      that.photoslider.removeClass( 'locked' );
      that.fotorama.show( index );

      $( 'html' ).addClass( 'fotorama-hook' );
      $( 'html' ).css( 'overflow', 'hidden' );
      $( 'body' ).css('overflow','hidden');
      
      that.overlay.css( 'opacity', 0 );
      $( 'body' ).append( that.overlay );

      if ( that.overlay.height() < that.overlay.find( '.fotorama-wrapper' ).height() ) {
        
        that.close.removeClass( 'absolute' );

      } else {

        that.close.addClass( 'absolute' );

      };

      setTimeout( function() {

        that.overlay.animate({ opacity: 1 }, 300 );

      }, 200 );

    },

    _closePhotoModal: function()
    {

      var that = this;
      that.overlay.animate( { opacity: 0 }, 300, function() {
        
        $( 'html' ).removeClass( 'fotorama-hook' );
        $( 'html' ).css( 'overflow', 'auto' );
        $( 'body' ).css( 'overflow', 'auto' );
        that.photoslider.addClass( 'locked' );
        that.photoslider.appendTo( $( 'body' ) );
        that.overlay.remove();

      });
      
    }
  };


  function initSpotlight() {

    var link = $( '.js-spotlight-link' );
    var modal = $( '.js-spotlight-modal' );
    var overlay = $( '.js-spotlight-overlay' );
    var close = $( '.js-spotlight-close' );

    modal.css( 'display', 'none' );

    link.click( function( event ) {

      modal.css({ opacity: 0, display: 'block' }).animate({ opacity: 1 }, 300, function() {

        modal.find( 'input[type="text"]' ).focus();

      });
      $( 'html' ).css( 'overflow-y', 'hidden' );
      if ( $( 'body' ).height() > $( window ).height() ){
        $( 'body' ).css( 'overflow-y', 'scroll' );
      } else{
        $( 'body' ).css( 'overflow-y', 'hidden' );
      }
      event.preventDefault();

    });
    
    overlay.click( function( event ) {

      closeThis();

    });
    close.click( function( event ) {

      closeThis();
      event.preventDefault();

    });

    function closeThis() {

      modal.css({ opacity: 1 }).animate({ opacity: 0 }, 300, function() {
        
        modal.css( 'display', 'none' );

      });

      $( 'html' ).css( 'overflow-y', 'auto' );
      $( 'body' ).css( 'overflow-y', 'auto' );

    }

  }

  (function initApp()
  {
    $('.ikselect').createIkselect();
    user_menu.init($('.user_menu'));

    PageNav.init();
    FlipCard.init();
    ModalHandler.init();
    Likes.init();    
    Comments.init();
    Share.init();

    initPhotoSlider.init();
    statuses.init();

    searchUPdContent();
    showPageToggler();
    jmodInit();
    btn_back();
    addMark();
    userRandomize();
    feedShow();
    // search.init();
    tooltipsInit();
    // formToggler();
    feedOverflow();
    initCoverImages();
    initDots();
    initSlider();
    initAutoheightTextarea();
    initSpotlight();
  })();


  });
