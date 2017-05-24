module.exports = (ctx) => ({
  input: "web/static/css/app.css",
  output: "priv/static/css/app.css"
  plugins: [
    require('autoprefixer')(['last 3 versions']),
    require('precss')(),
    require('cssnano')()
  ]
})
