//= require rails-ujs
//= require turbolinks
//  require better-dom
//  require better-dateinput-polyfill/dist/better-dateinput-polyfill.min.js
//= require moment
//= require moment-timezone-with-data
//= require bootstrap4-datetimepicker/build/js/bootstrap-datetimepicker.min
//= require_tree ./elements
//
document.addEventListener("turbolinks:load", function() {
  $('[data-toggle="tooltip"]').tooltip()
  $('.datetimepicker').datetimepicker({
     format: 'YYYY-MM-DD HH:mm'
  })
})
