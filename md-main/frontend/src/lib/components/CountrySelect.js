import React from 'react';
import Routes from 'routes';
import Autocomplete from "./Autocomplete";

export default function(props) {
  return (
    <Autocomplete {...props}
      name="country_id"
      urlBuilder={Routes.api_web_countries_path}
      collection="countries" />
  );
}

