$ ->
  $("form.category-form").bind('ajax:success', (e, data, status, xhr)->
    window.location.href = "/admin/categories"
  ).bind('ajax:error',  (event, data, status, xhr) ->
    $(".category-form input, .category-form input").removeClass("error")
    $(".error-text").remove()
    object = data.responseJSON
    $.each(object, (key, value)->
      $(".category-form #category_#{key}").addClass("error").parent().append("<div class='error-text'>#{value[0]}</div>")))

  $(".delete-category").click ->
    category = $(this).data("category")
    item = $(this).closest(".category_item")
    $.ajax "/admin/categories/#{category}",
      type: "DELETE"
      success: ->
        item.fadeOut('slow')

  $(".toggle-description").click (event) ->
    button = $(this)
    if $(this).hasClass("glyphicon-arrow-up")
      $(".category-desc").slideUp('slow')
      button.text("Показать")
      button.removeClass("glyphicon-arrow-up").addClass("glyphicon-arrow-down")
    else
      $(".category-desc").slideDown('slow')
      button.text("Скрыть")
      button.removeClass("glyphicon-arrow-down").addClass("glyphicon-arrow-up")