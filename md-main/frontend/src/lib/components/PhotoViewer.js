import React from "react";
import { connect } from "react-redux";
import { push } from 'react-router-redux';

class PhotoViewer extends React.Component {
  render() {
    return (
      <div></div>
    );
  }
}

export default connect(
  (state, ownProps) => ({
    ownProps
  })
)(PhotoViewer);