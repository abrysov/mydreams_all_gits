const webpack = require("webpack");
const baseConfig = require("./webpack.base");

module.exports = Object.assign({}, baseConfig, {
  cache: true,
  debug: true,
  devtool: "#eval-source-map",
  plugins: [
    new webpack.DefinePlugin({
      "process.env.NODE_ENV": JSON.stringify(process.env.RAILS_ENV)
    })
  ]
});
