import { request, requestJson, getJson }  from 'lib/ajax';

export function loadVipCertificate() {
  return getJson(Routes.api_web_products_path({ vip_statuses: true }))
  .then((r) => r.products[0]);
}

export function loadCertificates() {
  const url = Routes.api_web_products_path({ certificates: true });
  return getJson(url).then((r) => r.products);
}

export function buyCertificate(certificateId, dreamId, comment = "") {
  const url = Routes.api_web_purchases_certificates_path();

  return requestJson(url, "POST", {
    destination_id: dreamId,
    product_id: certificateId,
    comment
  });
}

export function buyVip(certificateId, dreamerId, comment = "") {
  const url = Routes.api_web_purchases_vip_statuses_path();

  return requestJson(url, "POST", {
    destination_id: dreamerId,
    product_id: certificateId,
    comment
  });
}
