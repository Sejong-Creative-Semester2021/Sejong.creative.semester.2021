'use strict'
const utils = require('./utils')
const config = require('../config')
const isProduction = process.env.NODE_ENV === 'production'
const BundleTracker = require('webpack-bundle-tracker')

module.exports = {
  loaders: utils.cssLoaders({
    sourceMap: isProduction
      ? config.build.productionSourceMap
      : config.dev.cssSourceMap,
    extract: isProduction
  }),
  transformToRequire: {
    video: 'src',
    source: 'src',
    img: 'src',
    image: 'xlink:href'
  },
  publicPath: "http://127.0.0.1:8080/",
  outputDir: "./dist/",

  chainWebpack: config => {
      config.optimization.splitChunks(false)

      config.plugin('BundleTracker').use(BundleTracker, [
          {
              filename: './webpack-stats.json'
          }
      ])

      config.resolve.alias.set('__STATIC__', 'static')

      config.devServer
          .public('http://0.0.0.0:8080')
          .host('0.0.0.0')
          .port(8080)
          .hotOnly(true)
          .watchOptions({poll: 1000})
          .https(false)
          .headers({'Access-Control-Allow-Origin': ['\*']})
  }
}
