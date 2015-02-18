loadCircle = (element, show)->
  if show
    $("body").css("opacity", 0.5)
    $("body").after(element)
  else
    $("body").css("opacity", 1)
    element.remove()


$ ->
  gif = $("<img src='/assets/ajax-loader.gif' class='js-ajax-load-image'/>")
  $(document).ajaxStart ->
    loadCircle(gif, true)
  $(document).ajaxComplete ->
    loadCircle(gif, false)