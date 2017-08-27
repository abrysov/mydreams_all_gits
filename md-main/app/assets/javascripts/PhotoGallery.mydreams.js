//Модуль отвечает за загрузку фотографий, отображение превью и перерисовку страницы с фотографиями.
//Используются masonry.js и plupload
//Страница с фотками в текущей реализации сайта недоступна, возможно этот код больше не актуален.

var PhotoGallery = (function($){
  var methods = {};

  return {
    init: function()
    {
      var loader_btn = $('#js-photo-loader');

      if (loader_btn) {
        methods.url = loader_btn.closest('form').attr('action');
        methods.filelist = $('.js-filelist');
        methods.upload_btn = $('.js-uploadfiles');
        methods.photos = $('#js-photos');
        methods.form_edit = $('.js-caption-form');

        $(document).off('click', '.js-photo-edit').on('click', '.js-photo-edit', function(){
          if(methods.form_edit.is(':visible')){
            return;
          }

          methods.caption = methods.form_edit.next('p');
          methods.form_edit.find('textarea').focusin().val(methods.caption.text());
          methods.form_edit.fadeIn();
        });

        methods.form_edit
          .off('ajax:success').on('ajax:success', function(e, xhr){
            methods.caption.text(xhr.caption);
            methods.form_edit.fadeOut();
          })

          .off('ajax:error').on('ajax:error', function(e, xhr){
            //TODO: handler
          });

        _uploaderInit();
        _masonryInit();
      };
    }
  };

  function _uploaderInit()
  {
    methods.loader = new plupload.Uploader({
      runtimes : "html5",
      browse_button : 'js-photo-loader',
      filters: {
        mime_types : [
          { title : "Image files", extensions : "jpeg,jpg,gif,png" }
        ],
        max_file_size : '10mb',
        prevent_duplicates: true
      },
      url : methods.url,
      multipart: true,
      urlstream_upload: true,
      multipart_params: {
        '<%= request_forgery_protection_token %>': '<%= form_authenticity_token %>',
        '<%= Rails.application.config.session_options[:key] %>': '<%= request.session_options[:id] %>'
      }
    });

    methods.loader.init();

    methods.loader.bind('FilesAdded', function (uploader, files){
      $.each(files, function(i){
        var
        file = this,
        preloader = new mOxie.Image();

        preloader.onload = function() {
          var
          file_id = this.uid,
          image = $('<img src="'+ preloader.getAsDataURL() +'"/>'),
          image_container = $('<div class="file-container js-file-container" id="'+ file_id +'"> data-item="'+ i +'"')
            .append('<b></b>')
            .append('<div class="file-rm js-file-rm>&times;</div></div>')
            .append(image);

          methods.filelist.append(image_container);
          methods.upload_btn.fadeIn();
        };

        preloader.load(this.getSource());
      });
    });

    methods.loader.bind('FileUploaded', function (uploader, file, ret) {

      methods.photos.prepend(ret.response).imagesLoaded(function(){
        methods.photos.masonry('reloadItems');
        methods.photos.masonry('layout');
      });

      methods.filelist.html('');
      methods.upload_btn.fadeOut();
    });

    methods.loader.bind('Error', function (uploader, error) {
      $('#' + error.file.id + " b").html('error');
    });

    $(document).off('click', '#js-photo-loader-btn').on('click', '#js-photo-loader-btn', function() {
      methods.loader.start();
    });
  };

  function _masonryInit()
  {
    methods.photos.imagesLoaded(function(){
      methods.photos.masonry({
        itemSelector: '.js-photo',
        columnWidth: 260,
        gutter: 20
      });
    });
  };

})(jQuery);



