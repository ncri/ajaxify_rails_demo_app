# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

  $('#ajaxify').click ->
    location_without_params = window.location.href.replace /\?ajaxify_(on|off)=true/, ''
    if this.checked
      window.location.href = location_without_params + '?ajaxify_on=true'
    else
      window.location.href = location_without_params + '?ajaxify_off=true'




