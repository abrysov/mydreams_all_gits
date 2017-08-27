import 'whatwg-fetch';


function checkStatus(response) {
  if (response.status >= 200 && response.status < 300) {
    return response;
  } else {
    const error = new Error(response.statusText);
    error.response = response;
    throw error;
  }
}

export function requestJson(url, method = "GET", data = null) {
  const params = {
    method,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'X-CSRF-Token': document.querySelector( 'meta[name="csrf-token"]' ).getAttribute( 'content' )
    },
    credentials: 'same-origin'
  };

  if (data) {
    params.body = JSON.stringify(data);
  }

  return fetch(url, params).then(checkStatus);
}

export function request(url, method = 'GET', formData) {
  const params = {
    method,
    headers: {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'X-CSRF-Token': document.querySelector( 'meta[name="csrf-token"]' ).getAttribute( 'content' )
    },
    credentials: 'same-origin',
    body: formData
  };

  return fetch(url, params).then(checkStatus);
}

export function getJson(url) {
  return requestJson(url).then((r) => r.json());
}
