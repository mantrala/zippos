# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".search-query").keyup ->
    if this.value.length > 0
      $('.search').addClass('blue')
      $('.search').prop('disabled', false)
    else
      $('.search').removeClass('blue')
      $('.search').prop('disabled', true)