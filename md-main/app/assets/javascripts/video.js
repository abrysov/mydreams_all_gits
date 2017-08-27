$(function(){
  $('#video').css({ width: ($(window).innerWidth() * 0.8) + 'px', height: ($(window).innerHeight() * 0.8) + 'px' });

  $(window).resize(function(){
    $('#video').css({ width: ($(window).innerWidth() * 0.8) + 'px', height: ($(window).innerHeight() * 0.8) + 'px' });
  });

  // NOTE: you dont want to struggle with this shit. Just remove it and write new shiny code
  $('body').on('click', '.jmod-overlay', function() {
    $('.jmod-overlay').removeClass('jmod-overlay--visible').addClass('jmod-overlay--invisible');
    if ($('#disable-video').length > 0) {
      $('#certificate_video').remove();
      window.top.location.search = '';
    }
    $('#video').attr('src', '');
  });

  $('body').on('click', '.jmod-overlay #disable-video', function() {
    $('.jmod-overlay').addClass('.jmod-overlay--invisible');
    if ($('#disable-video').length > 0) {
      $('#certificate_video').remove();
      window.top.location.search = '';
    }
    $('#video').attr('src', '');
  });

  $('#certificate_video_play').on('click', function() {
    var video_id = $('#certificate_video_play').data('videoId');
    $('#certificate_video').html('<div class="jmod-overlay jmod-overlay--visible"><div class="jmod-wrapper"><div class="jmod-scroller"><div class="jmod-window"><div class="jmod-content"><div class="video"><iframe allowfullscreen="true" frameborder="0" id="video" src="https://www.youtube.com/embed/' + video_id + '?rel=0&amp;controls=0&amp;showinfo=0;autoplay=1"></iframe></div></div><div class="jmod-close-button" id="disable-video"></div></div></div></div></div>')
    $('#video').css({ width: ($(window).innerWidth() * 0.8) + 'px', height: ($(window).innerHeight() * 0.8) + 'px' });
    $('#certificate_video_play').hide();
  })
});
