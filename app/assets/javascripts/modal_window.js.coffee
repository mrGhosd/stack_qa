$ ->
  $(".authentication-links a").click ->
    $('#myModal ul.nav.nav-tabs li, #myModal .tab-content .tab-pane').removeClass('active')
    action = $(this).data("action")
    $("#myModal").find("a[href=##{action}]").parent().addClass("active")
    $("#myModal").find("##{action}.tab-pane").addClass("active")
    $("#myModal").modal()

  $('#myModal ul.nav.nav-tabs a').click (event)->
    event.preventDefault()
    $(this).tab('show')

  $("#myModal .form-delegate").click ->
    $("#myModal input").removeClass("error")
    $("#myModal .error-text").remove()
    form = $("#myModal .tab-content .tab-pane.active").find("form")
    url = $(form).attr("action")
    $.ajax url,
      type: "POST"
      data: form.serialize()
      dataType: "json"
      success: (data, textStatus, jqXHR)->
        window.location.reload()
      error: (jqXHR, textStatus, errorThrown) ->
        object = JSON.parse(jqXHR.responseText)
        if url == "/users/sign_in"
          $("#myModal form input").addClass("error")
          $("#myModal form #user_password").parent().append("<div class='error-text'>#{object.error}</div>")

        $.each(object.errors, (key, value)->
          $("#myModal #user_"+key).addClass("error")
          $.each(value, (element) ->
            $("#myModal #user_"+key).parent().append("<div class='error-text'>#{value[element]}</div>")
          )
        )
  $(".social-networks-auth a.facebook").click (event)->
    event.preventDefault()
    url = $(this).attr("href")
    window.location.href = url

  $(".social-networks-auth a.twitter").click (event)->
    event.preventDefault()
    url = $(this).attr("href")
    form = JST["templates/twitter-email"]
    showModalMessage(form)

    $(".twitter-additional-emal .submit-twitter-email").click (event) ->
      event.preventDefault()
      event.stopPropagation()
      $("#messageModal").remove()
      window.location.href=url+"?email="+$(".twitter-email").val()


@showModalMessage = (message)->
  $('body').prepend JST["templates/modal"]
  if $("#myModal")
    $("#myModal").modal('hide')
  $("#messageModal .modal-body").prepend message
  $("#messageModal").modal('show')


