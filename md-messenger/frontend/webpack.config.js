var path = require('path');
var outputPath = path.resolve(__dirname, '../priv/static');

var config = {
    entry: "./src/app.jsx",
    output: {
        path: outputPath,
        filename: "bundle.js"
    },
    resolve: {
        extensions: ["", ".js", ".jsx"]
    },
    module: {
      loaders: [
        {
          test: /\.jsx?$/,
          exclude: /(node_modules|bower_components)/,
          loader: 'babel',
          query: {
            presets: ['react', 'es2015']
          }
        }
      ]
    }
};

module.exports = config;
