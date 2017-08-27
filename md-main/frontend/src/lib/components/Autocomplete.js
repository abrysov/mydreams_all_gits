import { getJson } from "lib/ajax";
import React from 'react';
import Select from 'react-select';

import "react-select/dist/react-select.min.css";

export default class Autocomplete extends React.Component {
  getLoadOptions(q) {
    const { urlBuilder, urlParams = {}, collection } = this.props;
    const url = urlBuilder({ ...urlParams, q });

    return getJson(url).then((json) => ({ options: json[collection] }));
  }

  render() {
    const { value, onChange } = this.props;

    return (
      <div className="select">
        <Select.Async
            value={value}
            valueKey="id"
            labelKey="name"
            onChange={(item) => onChange(item ? item.id: -1)}
            loadOptions={this.getLoadOptions.bind(this)} />
        </div>
    );
  }
}
