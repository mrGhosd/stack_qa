#$(document).delegate(".category-form", "submit", (event)->
#  event.preventDefault()
#  event.stopPropagation()
#  event.stopImmediatePropagation()
#  $(".category-form input, .category-form input").removeClass("error")
#  $(".error-text").remove()
#  url
#  type
#  action = $("#category_action")
#
#  if action.length > 0
#    url = "/admin/categories/#{action.data('category')}"
#    type = "PATCH"
#  else
#    url = "/admin/categories"
#    type = "POST"
#
##  attributes = {}
##  elements = $('input, select, textarea', $(".category-form"))
##
##  for element in elements
##    if $(element).attr("type") == "submit"
##      continue
##    if $(element).attr("type") == "file"
##      attributes[$(element).attr('name')] = $(element)[0].files[0] if $(element)[0].files[0]
##      continue
##
##    attributes[$(element).attr('name')] = $(element).val()
#
#  $.ajax url,
#    type: type
#    data: $(".category-form").serialize()
#    success: (data)->
#      window.location.href = "/admin/categories"
#    error: (error) ->
#      console.log error
#      object = error.responseJSON
#      $.each(object, (key, value)->
#        $(".category-form #category_#{key}").addClass("error").parent().append("<div class='error-text'>#{value[0]}</div>")
#      )
#)
$ ->
  $("form.category-form").bind('ajax:success', (e, data, status, xhr)->
    window.location.href = "/admin/categories"
  ).bind('ajax:error',  (event, data, status, xhr) ->
    $(".category-form input, .category-form input").removeClass("error")
    $(".error-text").remove()
    object = data.responseJSON
    $.each(object, (key, value)->
      $(".category-form #category_#{key}").addClass("error").parent().append("<div class='error-text'>#{value[0]}</div>")))