//С помощью этого модуля осуществляется шаринг мечтаний и записей в социальные сети.

var Share = (function($){

  function _vkontakte(purl, ptitle, pimg, text)   
  {
    url  = 'http://vkontakte.ru/share.php?';
    url += 'url='          + encodeURIComponent(purl);
    url += '&title='       + encodeURIComponent(ptitle);
    url += '&description=' + encodeURIComponent(text);
    url += '&image='       + encodeURIComponent(pimg);
    url += '&noparse=true';
    _popup(url);
  };

  function _odnoklassniki(purl, text) 
  {
    url  = 'http://www.odnoklassniki.ru/dk?st.cmd=addShare&st.s=1';
    url += '&st.comments=' + encodeURIComponent(text);
    url += '&st._surl='    + encodeURIComponent(purl);
    _popup(url);
  };

  function _facebook(purl, ptitle, pimg, text) 
  {
    url  = 'http://www.facebook.com/sharer.php?s=100';
    url += '&p[url]='       + encodeURIComponent(purl);
    url += '&p[images][0]=' + encodeURIComponent(pimg);
    url += '&p[title]='     + encodeURIComponent(ptitle);
    url += '&p[summary]='   + encodeURIComponent(text);
    _popup(url);
  };

  function _twitter(purl, ptitle) 
  {
    url  = 'http://twitter.com/share?';
    url += 'text='      + encodeURIComponent(ptitle);
    url += '&url='      + encodeURIComponent(purl);
    url += '&counturl=' + encodeURIComponent(purl);
    _popup(url);
  };

  function _google_plus(purl, ptitle) 
  {
    url  = 'https://plus.google.com/share?';
    url += 'text='      + encodeURIComponent(ptitle);
    url += '&url='      + encodeURIComponent(purl);
    _popup(url);
  };

  function _popup(url) 
  {
    window.open(url,'','toolbar=0,status=0,width=626,height=436');
  };

  return {

    init: function()
    {
      $(document).off('click', '.js-share').on('click', '.js-share', function(e){
        
        var 
        provider    = $(this).data('type'),
        title       = $(this).data('title'),
        description = $(this).data('description'),
        url         = $(this).data('url');

        if ($(this).data('img') != undefined) {
          img_url = window.location.hostname + $(this).data('img');
        }else {
          img_url = '';
        }

        switch(provider){
          case('vkontakte'):
            _vkontakte(url, title, description, img_url);
            break;
          case('facebook'):
            _facebook(url, title, description, img_url);
            break;
          case('odnoklassniki'):
            _odnoklassniki(url, description);
            break;
          case('twitter'):
            _twitter(url, title);
            break;
          case('google_plus'):
            _google_plus(url, title);
            break;                                    
        }

      });
    }
  };

})(jQuery);
