//= require rails-ujs
//= require turbolinks
//= require better-dom
//= require better-dateinput-polyfill/dist/better-dateinput-polyfill.min.js
//= require_tree ./elements
//
document.addEventListener("turbolinks:load", function() {
  $('[data-toggle="tooltip"]').tooltip()
})
