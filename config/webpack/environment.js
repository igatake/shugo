const { environment } = require("@rails/webpacker");

const webpack = require("webpack");

environment.plugins.prepend(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery/src/jquery",
    jQuery: "jquery/src/jquery",
    Popper: ["popper.js", "default"]
  })
);

environment.config.set("output.library", ["Packs", "[name]"]);

module.exports = environment;
