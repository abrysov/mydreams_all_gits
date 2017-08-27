import _ from "lodash";

function filterQueryKeys(query) {
  return _.pickBy(query, (v) => {
    if (_.isNumber(v)) { return v > 0; }
    if (_.isBoolean(v)) { return v; }
    if (_.isString(v)) { return v.length > 0; }

    return !!v;
  });
}

export function buildRouterDreamsUrl(query, data) {
  const result = { ...query, ...data };
  return { pathname: window.location.pathname, query: filterQueryKeys(result) };
}

export function buildRouterDreamersUrl(query, data) {
  const result = { ...query, ...data };
  return { pathname: window.location.pathname, query: filterQueryKeys(result) };
}

export function buildRouterCertificatesUrl(query, data) {
  const result = { ...query, ...data };
  return { pathname: window.location.pathname, query: filterQueryKeys(result) };
}
