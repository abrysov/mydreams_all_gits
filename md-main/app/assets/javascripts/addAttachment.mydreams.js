$(function(){

  var attachment = {

    init: function ()
    {      
      var that = this;

      $(document).off('change', '.js-attachment').on('change', '.js-attachment', function(e){
        var 
        files = e.target.files;

        that.attachment_container = $('.js-attachment-container');

        that.attachment_container.html('');        

        for (var i = files.length - 1; i >= 0; i--) {
          that.createPreview(files[i]);
        };
      });
    },

    createPreview: function (file) 
    {
      var 
      that = this;

      //html5 browser
      if (FileReader){
        var reader = new FileReader();

        reader.onload = function(e)
        {
          var 
          file_wrap = $('<div></div>').attr('class', 'attachment-item'),
          file_obj = new Image();

          if (file.type.match('image.*')){
            $(file_obj)
              .attr('src', e.target.result)
              .attr('type', file.type);

            $(file_obj).appendTo(file_wrap);
            file_wrap.appendTo(that.attachment_container);  
          }
        }
        reader.readAsDataURL(file); 
      }else{
      //all browser
        file_wrap.append('<p>' + file.name + '</p>');
      }
    }
  }

  attachment.init();
});