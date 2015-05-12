$ ->
  $(".profile-navigation a").click (event) ->
    event.preventDefault()
    page = $(this).data("page")
    $(".profile-navigation li").removeClass("active")
    $(this).tab('show').parent().addClass("active")
    $(".profile-pages>div").removeClass("active")
    $(".profile-pages>##{page}").addClass("active")

  $(".user-edit-form").on("load", ->
    alert "1"
  )
  $("#profile .edit-user").click ->
    editUser($(this))

$(document).delegate(".user-image", "change", ->
  reader = new FileReader()
  reader.onload = (event) ->
    dataUri = event.target.result
    img = new Image(200, 200)
    img.class = "avatar"
    img.src = dataUri
    $(".user-avatar").html(img)
  reader.onerror = (event) ->
    console.log "ОШИБКА!"
  image = $(".user-edit-form .user-image")[0].files[0]
  reader.readAsDataURL(image)
)





editUser = (button) ->
  user = button.data("user")
  $.ajax "/users/#{user}/edit",
    type: "GET"
    success: (response, request) ->
      showUserModalWindow("Редактировать пользователя", response)
    error: (response, request) ->
      showUserModalWindow("Ошибка при загрузке", response)


showUserModalWindow = (title, main)->
  $("body").prepend JST["templates/modal"]
  $("#messageModal .modal-dialog").addClass("modal-lg")
  $("#messageModal .modal-title").html(title)
  $("#messageModal .modal-body").html(main)
  $("#messageModal").modal('show')
  $(".datepicker").datepicker({dateFormat: "dd.mm.yy", changeMonth:true, changeYear:true, yearRange: '1900:2099'});
