// TODO: вынести фильтры в отдельный плагин, добавить описание
// Плагин предназначен для обработки в браузере загружаемых изображений(кроп, превью) и отправки на сервер в виде строки base64.
// Требует также наличие mOxie.js.
// Опционально принимает 3 значения:
// - min_height - минимальная требуемая высота будующего изображения;
// - min_width - минимальная требуемая ширина будующего изображения;
// - orient - ориентация будущего изображения. Может быть двух форматов: 'list' и  'square'.
// Значения по умолчанию - 600, 600, 'square'.

(function($){

  var methods = {

    init: function(init_options)
    {
      return this.each(function(){
        var
        canvas,
        $this = $(this),
        data = $this.data('imageLoader');

        if (! data) {
          var
          $target_form = $('.js-imageLoader-form'),
          $save_btn = $target_form.find('.js-imageSaver'),
          btn = $this.attr('id'),
          $filters = $target_form.find('.js-photo-filter'),

          options = $.extend({
              min_height: $this.data('minHeight') || 600,
              min_width: $this.data('minWidth') || 600,
              orient: $this.data('orient') || 'square'
          }, init_options),

          fileInput = new mOxie.FileInput({
            browse_button: btn,
            accept: [
              {title: "Image files", extensions: "jpeg,jpg,gif,png"}
            ]
          });

          $this.data('imageLoader', {
              init: true
          });

          fileInput.onchange = function(e) {
            var image = new mOxie.Image();

            image.onload = function() {

              // Если требуется ручной кроп и это не тач устройство показываем кропалку, иначе кропаем сами
              if( options.crop == true && $('html').hasClass('no-touch') ) {
                methods._handCropImage($this, $target_form, image, options);
              }else {
                methods._autoCropImage($this, $target_form, image, options);
              }

              // Если это форма с ручной кропалкой, переключаем кнопки "Загрузить"/"Сохранить" и скрываем загрузчик
              if ($save_btn.length) {
                $this.removeClass('active');
                $save_btn.addClass('active');
                $("#" + fileInput.ruid + "_container").css('display', 'none');
              };
            };

            image.load(this.files[0]);
          };

          fileInput.init();
        };
      });
    },

    _autoCropImage: function($this, $target_form, image, options)
    {
      var
      $container = $target_form.find(".js-imageLoader-preview"),
      load_img_width = image.width,
      load_img_height = image.height,
      options_min_height = options.min_height,
      options_min_width = options.min_width,
      ratio = options_min_width / options_min_height,
      orient = options.orient,
      preview = new Image(),
      crop_width,
      crop_height,
      min_side;

      if (orient == 'list') {
          width = load_img_width;
          height = load_img_width / ratio;

          if (height > load_img_height) {
            height = load_img_height;
            width = load_img_height * ratio;
          };

          image.crop(width, height, false);
          image.width = options_min_width;
          image.height = options_min_height;

          _successLoadHandler();
      }

      if (orient == 'square') {
        min_side = load_img_width < load_img_height ? load_img_width : load_img_height;
        width = min_side;
        height = min_side / ratio;
        image.crop(width, height, false);
        image.width = options_min_width;
        image.height = options_min_height;

        _successLoadHandler();
      };

      function _successLoadHandler()
      {
        $(preview).attr('src', image.getAsDataURL()).css('max-width', '100%');
        $(preview).addClass('visible');

        $container.html(preview);

        $container.siblings( '.upload-photo' ).removeClass( 'upload-photo' ).addClass( 'change-photo' );

        $target_form.find('.js-imageLoader-input').val(image.getAsDataURL());

        if (options.beforeLoaded) {
          options.beforeLoaded($target_form);
        };

        // PhotoFilter.init();
      }
    },

    _handCropImage: function($this, $target_form, image, options)
    {
      var
      $container = $target_form.find(".js-imageLoader-preview"),
      $input = $target_form.find('.js-imageLoader-input'),
      load_img_width = image.width,
      load_img_height = image.height,
      crop_img_width = $container.width(),
      preview = new Image(),
      input_name = $this.data('inputName'),
      crop_inputs = [input_name + '_crop_x', input_name + '_crop_y', input_name + '_crop_h', input_name + '_crop_w'],
      ratio_width = options.min_width/options.min_height,
      ratio_height = 1;

      $(preview).attr('src', image.getAsDataURL());

      $container.html($(preview));

      $input.val(image.getAsDataURL());

      for (var i = 0;  i < crop_inputs.length; i++) {
        $target_form.append('<input type="hidden" id="'+ crop_inputs[i] +'" name="'+ crop_inputs[i] +'" value="'+ crop_inputs[i] +'"/>');
      };

      $(preview).Jcrop({
        aspectRatio: ratio_width / 1,
        onChange: update_crop,
        onSelect: update_crop,
        onRelease: set_default,
        trueSize: [image.width, image.height],
        setSelect: [50, 50, (300 * ratio_width), (300 * ratio_height)],
        boxWidth: $container.innerWidth()
        // boxHeight: 250
      });

      // Если пользователь сбросил кропалку, кропаем сами
      function set_default()
      {
        methods._autoCropImage($this, $target_form, image, options);

        $("#" + input_name + "_crop_x").val('');
        $("#" + input_name + "_crop_y").val('');
        $("#" + input_name + "_crop_h").val('');
        $("#" + input_name + "_crop_w").val('');
      }

      function update_crop(coords)
      {
        var ratio = 1;
        $("#" + input_name + "_crop_x").val(Math.round(coords.x * ratio));
        $("#" + input_name + "_crop_y").val(Math.round(coords.y * ratio));
        $("#" + input_name + "_crop_h").val(Math.round(coords.h * ratio));
        $("#" + input_name + "_crop_w").val(Math.round(coords.w * ratio));
      }
    }

    // destroy: function()
    // {
    //   return this.each(function(){
    //     var
    //     $this = $(this),
    //     this_data = $this.data('form_data'),
    //     container = $this.data('form_data').target_form.find(".js-dream-preview"),
    //     input = $this.data('form_data').target_form.find('#dream_photo'),
    //     filters = $this.data('form_data').target_form.find('.js-photo-filter');

    //     $this.removeClass('dreamImgLoader');

    //     this_data.fileInput.destroy();

    //     if (this_data.texture) {
    //       this_data.texture.destroy();
    //     };

    //     if (this_data.texture_filter_preview) {
    //       $.each(this_data.texture_filter_preview, function(){
    //         $(this)[0].destroy();
    //       });
    //     };

    //     container.html('');

    //     filters.html('');

    //     input.val('');

    //     $(window).unbind('.dreamImgLoader');

    //     $this.removeData('form_data');
    //   });
    // },

    // _setupFilter: function(canvas, texture, elem, target_form)
    // {
    //   var new_img = new Image();

    //   switch(elem.data('effect')){
    //     case 'retro':
    //       canvas.draw(texture).hueSaturation(0, -1).update();
    //       break;
    //     case 'sepia':
    //       canvas.draw(texture).sepia(1).update();
    //       break;
    //     case 'watercolor':
    //       canvas.draw(texture).denoise(15).update();
    //       break;
    //     case 'saturation':
    //       canvas.draw(texture).hueSaturation(0, -0.5).update();
    //       break;
    //     case 'tilt_shift':
    //       canvas.draw(texture).tiltShift(96, 359.25, 480, 287.4, 10, 200).update();
    //       break;
    //     case 'zoom_blur':
    //       canvas.draw(texture).zoomBlur(320, 239.5, 0.3).update();
    //       break;
    //     case 'dot_screen':
    //       canvas.draw(texture).dotScreen(320, 239.5, 1.1, 3).update();
    //       break;
    //     case 'vigenette':
    //       canvas.draw(texture).vignette(0.5, 0.5).update();
    //       break;
    //     case 'vibrance':
    //       canvas.draw(texture).vibrance(0.5).update();
    //       break;
    //     default:
    //       canvas.draw(texture).update();
    //       break;
    //   }

    //   if (elem.hasClass('js-dream-preview')) {
    //     methods._setupVal(canvas);
    //   };

    //   $(new_img).attr('src', canvas.toDataURL());

    //   return new_img;
    // },

    // _setupVal: function(canvas)
    // {
    //   var input = methods.target_form.find('#dream_photo');

    //   input.val(canvas.toDataURL());
    // }

  }

  $.fn.imageLoader = function(method) {

    if ( methods[method] ) {
      return methods[method].apply( this, Array.prototype.slice.call( arguments ));
    } else if ( typeof method === 'object' || ! method ) {
      return methods.init.apply( this, arguments );
    } else {
      $.error( 'Method ' +  method + ' not fined jQuery.imageLoader' );
    }

  };
})(jQuery);
