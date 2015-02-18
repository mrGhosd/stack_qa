$ ->
  $(".profile-navigation a").click (event) ->
    event.preventDefault()
    page = $(this).data("page")
    $(".profile-navigation li").removeClass("active")
    $(this).tab('show').parent().addClass("active")
    $(".profile-pages>div").removeClass("active")
    $(".profile-pages>##{page}").addClass("active")

  $("#profile .edit-user").click ->
    editUser($(this))





editUser = (button) ->
  user = button.data("user")
  $.ajax "/users/#{user}/edit",
    type: "GET"
    success: (response, request) ->
      showUserModalWindow("Редактировать пользователя", response)
      console.log response
      console.log request
    error: (response, request) ->
      showUserModalWindow("Ошибка при загрузке", response)
      console.log response
      console.log request


showUserModalWindow = (title, main)->
  $("body").prepend JST["templates/modal"]
  $("#messageModal .modal-dialog").addClass("modal-lg")
  $("#messageModal .modal-title").html(title)
  $("#messageModal .modal-body").html(main)
  $("#messageModal").modal('show')