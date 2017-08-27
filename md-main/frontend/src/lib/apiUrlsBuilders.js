export function buildApiFulfilledDreamsUrl(urlParams, page) {
  if (!urlParams.gender) { urlParams.gender = "all"; }
  const requestParams = { fulfilled: true, gender: urlParams.gender, page, per: 21 };

  if (urlParams.search) { requestParams.search = urlParams.search; }

  return Routes.api_web_dreams_path(requestParams);
}

export function buildApiDreamerFulfilledDreamsUrl(dreamerId, urlParams, page) {
  const requestParams = { fulfilled: true, page, per: 21 };
  return Routes.api_web_dreamer_dreams_path(dreamerId, requestParams);
}

export function buildApiDreamsUrl(urlParams, page) {
  if (!urlParams.filter) { urlParams.filter = "top"; }
  const requestParams = { fulfilled: false, [`${urlParams.filter}`]: true, page, per: 21 };

  if (urlParams.search) { requestParams.search = urlParams.search; }

  return Routes.api_web_dreams_path(requestParams);
}

export function buildApiDreamerDreamsUrl(urlParams, userId, page) {
  const requestParams = { fulfilled: false, page, per: 21 };
  return Routes.api_web_dreamer_dreams_path(userId, requestParams);
}

export function buildApiDreamersUrl(urlParams, page, { widgetType, dreamerId }) {
  const requestParams = { page, per: 21 };

  ['gender', 'hot', 'vip', 'online', 'new', 'city_id', 'country_id', 'search'].forEach((k) => {
    if (urlParams[k]) requestParams[k] = urlParams[k];
  });

  ['from', 'to'].forEach((k) => {
    if (urlParams[k]) requestParams[`age[${k}]`] = urlParams[k];
  });

  switch(widgetType) {
    case 'all_dreamers':
      return Routes.api_web_dreamers_path(requestParams);
    case 'dreambook_friends':
      return Routes.api_web_dreamer_friends_path(dreamerId, requestParams);
    case 'dreambook_friendships':
      return Routes.api_web_profile_friendship_requests_path(requestParams);
    case 'dreambook_followers':
      return Routes.api_web_dreamer_followers_path(dreamerId, requestParams);
    case 'dreambook_followees':
      return Routes.api_web_profile_followees_path(requestParams);
    default:
      throw 'Unhandled widget type for DreamersList: ' + widgetType;
  }
}

export function buildApiLikeUrl(entity_type, entity_id) {
  return Routes.api_web_likes_path({ entity_type, entity_id });
}

export function buildApiUnlikeUrl(entity_type, entity_id) {
  return Routes.api_web_like_path(entity_id, { entity_type });
}

export function buildApiDreamer(dreamerId) {
  return Routes.api_web_dreamer_path(dreamerId);
}

export function buildApiDreamerPhotos(dreamerId, page) {
  const requestParams = { page, per: 39 };
  return Routes.api_web_dreamer_photos_path(dreamerId, requestParams);
}

export function buildApiCertificatesUrl(dreamerId, urlParams = {}, page) {
  const requestParams = { ...urlParams, page, per: 12 };
  return Routes.api_web_dreamer_certificates_path(dreamerId, requestParams);
}

export function buildApiUploadProfilePhotos() {
  return Routes.api_web_profile_photos_path();
}
