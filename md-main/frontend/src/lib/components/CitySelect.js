import React from 'react';
import Routes from 'routes';
import Autocomplete from "./Autocomplete";

export default function(props) {
  const { country_id } = props;

  return (
    <Autocomplete {...props}
      name="city_id"
      urlParams={{ country_id }}
      urlBuilder={Routes.api_web_country_cities_path}
      collection="cities" />
  );
}

