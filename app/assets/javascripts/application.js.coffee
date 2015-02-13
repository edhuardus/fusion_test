###
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require jquery.ui.datepicker
//= require jquery.ui.datepicker-es
//= require populate.address

###


# General DOM Ready.
$ ->
  #$('.datepicker').datepicker()
  $(".datepicker").datepicker({ maxDate: new Date, changeYear: true, yearRange: "-100:+0" });
  return

