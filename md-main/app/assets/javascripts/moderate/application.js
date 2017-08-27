//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap

$(function() {
  $('.dreamer-form-find-by-id').submit(function(){
    var id = $(this).find('.find-id').val();
    var url = $(this).attr('url');
    $(this).attr('action', url + '/' + id);
  });

  $('#to_top').click(function(){
    $(window).scrollTop(0);
  });

  $(window).on('beforeunload', function(){
    $(window).scrollTop(0);
  });
});

$(function () {
  $('[data-toggle="tooltip"]').tooltip();
});
