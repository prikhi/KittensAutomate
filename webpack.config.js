var path = require("path");
var webpack = require("webpack");

module.exports = {
  entry: {
    app: [
      './src/index.js',
    ],
  },

  output: {
    path: path.resolve(__dirname + '/dist'),
    filename: '[name].js'
  },

  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/,],
        use: {
          loader: 'elm-webpack-loader',
          options: {
            'warn': true,
            'verbose': true,
            'debug': true,
          },
        },
      },
    ],
  },

  devServer: {
    inline: true,
    host: '0.0.0.0',
    stats: {
      colors: true,
      chunks: false,
    },
  },

};
