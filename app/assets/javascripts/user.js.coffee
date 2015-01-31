$ ->
  $(".profile-navigation a").click (event) ->
    event.preventDefault()
    page = $(this).data("page")
    $(".profile-navigation li").removeClass("active")
    $(this).tab('show').parent().addClass("active")
    $(".profile-pages>div").removeClass("active")
    $(".profile-pages>##{page}").addClass("active")



