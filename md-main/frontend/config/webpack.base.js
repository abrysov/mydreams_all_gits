const path = require("path");

const ENV = process.env.RAILS_ENV || process.env.NODE_ENV;

module.exports = {
  output: {
    filename: "main.js",
    path: path.join(__dirname, "../../app/assets/javascripts/webpack/")
  },

  entry: path.join(__dirname, "../src/index.js"),

  externals: {
    "jquery": "jQuery",
    "routes": "Routes",
    "i18n": "I18n",
    "gon": "gon"
  },

  stats: {
    colors: true,
    reasons: true
  },

  resolve: {
    extensions: ["", ".js"],
    modulesDirectories: [ "frontend/src/", "node_modules" ]
  },

  eslint: {
    configFile: ".eslintrc"
  },

  module: {
    loaders: [{
      test: /\.js$/,
      exclude: /node_modules/,
      loader: "babel"
    },
    { test: /\.css$/, loader: "style-loader!css-loader" }
    ]
  }
};
