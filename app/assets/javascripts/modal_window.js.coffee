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
    console.log form.serialize()
    $.ajax url,
      type: "POST"
      data: form.serialize()
      dataType: "json"
      success: (data, textStatus, jqXHR)->
        window.location.reload()
      error: (jqXHR, textStatus, errorThrown) ->
        object = JSON.parse(jqXHR.responseText)
        $.each(object.errors, (key, value)->
          $("#myModal #user_"+key).addClass("error")
          $.each(value, (element) ->
            $("#myModal #user_"+key).parent().append("<div class='error-text'>#{value[element]}</div>")
          )
        )

