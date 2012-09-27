
Ajaxify.on_success = (data, status, jqXHR, url) ->
  $nav_links = $('#navigation a')
  $nav_links.removeClass 'active'
  $nav_links.filter( ->
    (window.location.pathname == $(this).attr('href') and window.location.hash == '') or   # for browsers with histori api
    window.location.hash == '#' + $(this).attr('href')                                     # for browsers without histori api
  ).addClass 'active'


flash_timeout = null

Ajaxify.flash_effect = (flash_type) ->
  flash_timeout = setTimeout( ->
    $("##{flash_type}").fadeOut()
  , 5000)

Ajaxify.clear_flash_effect = (flash_type) ->
  if flash_timeout
    clearTimeout flash_timeout


# Ajaxify.flash_types = ['notice', 'warning']


# Ajaxify.on_before_load = ->
#   alert 'before load'
#
# Ajaxify.on_success = ->
#   alert 'success'
#
# Ajaxify.on_success_once = ->
#   alert 'success once'


# Ajaxify.base_path_regexp = /^(\/fr|\/de)/i

