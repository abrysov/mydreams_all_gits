// TODO: refactor: удалить этот плагинчик и проверить что осталось после него

(function($){

  var methods = {

    init: function(init_options)
    {
      return this.each(function(){
        var
        $this = $(this),
        data = $this.data('imgCropper');

        if(! data){
          var
          options = $.extend({}, init_options),
          btn = $this.attr('id'),
          fileInput = new mOxie.FileInput({
            browse_button: btn,
            accept: [
              {title: "Image files", extensions: "jpeg,jpg,gif,png"}
            ]
          });

          $this.data('imgCropper', {
            init: true
          });

          fileInput.onchange = function(e) {
            var image = new mOxie.Image();

            image.onload = function() {
              var
              $target_form = $this.closest('.imgCropper-form'),
              $img_container = $target_form.find('.imgCropper-container'),
              $ctrls = $target_form.find('.imgCropper-ctrl'),
              $input = $target_form.find('.imgCropper-input'),
              baseFieldName = $target_form.data('crop'),
              load_img_width = image.width,
              load_img_height = image.height,
              crop_img_width = $img_container.width(),
              preview = new Image(),
              crop_img_height,
              ratio;

              $(preview).attr('src', image.getAsDataURL());

              $ctrls.toggleClass('active');

              $target_form.find('#imgCropper-save').prop('disabled', '');

              $img_container.html($(preview));

              $input.val(image.getAsDataURL());

              options.baseFieldName = baseFieldName;

              if ($('html').hasClass('no-touch')) {
                methods._cropImage(preview, options);
              };
            };

            image.load(this.files[0]);
          };

          fileInput.init();
        }
      });
    },

    _cropImage: function(img, options)
    {
      $(img).Jcrop({
        aspectRatio: options.ratio_w/options.ratio_h,
        onChange: update_crop,
        onSelect: update_crop,
        trueSize: [img.width, img.height],
        setSelect: [50, 50, (300 * options.ratio_w), (300 * options.ratio_h)],
        boxWidth: 512,
        boxHeight: 512
      });

      function update_crop(coords)
      {
        var ratio = 1;
        $("#" + options.baseFieldName + "_crop_x").val(Math.round(coords.x * ratio));
        $("#" + options.baseFieldName + "_crop_y").val(Math.round(coords.y * ratio));
        $("#" + options.baseFieldName + "_crop_h").val(Math.round(coords.h * ratio));
        $("#" + options.baseFieldName + "_crop_w").val(Math.round(coords.w * ratio));
      }
    }
  }

  $.fn.imgCropper = function(method) {
    if ( methods[method] ) {
      return methods[method].apply( this, Array.prototype.slice.call( arguments ));
    } else if ( typeof method === 'object' || ! method ) {
      return methods.init.apply( this, arguments );
    } else {
      $.error( 'Method ' +  method + ' not fined jQuery.imgCropper' );
    }
  };

})(jQuery);
