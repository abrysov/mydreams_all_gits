const webpack = require("webpack");
const baseConfig = require("./webpack.base");

module.exports = Object.assign({}, baseConfig, {
  cache: true,
  debug: false,
  devtool: false,
  plugins: [
    new webpack.optimize.OccurrenceOrderPlugin(),
    new webpack.optimize.DedupePlugin(),
    new webpack.DefinePlugin({
      "process.env.NODE_ENV": JSON.stringify(process.env.RAILS_ENV)
    })
  ]
});
