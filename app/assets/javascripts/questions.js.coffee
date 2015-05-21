$ ->
  $(".delete-question").click ->
    link = $(this).closest(".question-item")
    id = $(this).data("question")
    $.ajax
      url: "/questions/#{id}"
      type: "DELETE"
      success: ->
        link.fadeOut('slow')



  PrivatePub.subscribe "/questions", (data, channel) ->
    if $(".question-filters li.active").find("a").attr("filter") == "new"
      question = data.question
      $(".questions-list").prepend JST["templates/question"](question: question)
    else
      if $(".question-filters a[filter=new] span.badge").lenght > 0
        count = parseInt($(".question-filters a[filter=new] span.badge").text(), 10) + 1
      else
        count = 1
      $(".question-filters li").find("a[filter=new]").append("<span class='badge'>#{count}</span>")

  $(".sign-in-question").click ->
    signInQuestion($(this))

  $(".question-filters a").click ->
    questionFilter($(this))

  $(".complain-question").click ->
    complainQuestion($(this))


$(document).delegate(".question_form", "submit", (event)->
  event.preventDefault()
  event.stopPropagation()
  event.stopImmediatePropagation()
  $(".question_form input, .question_form textarea").removeClass("error")
  $(".error-text").remove()
  url
  type
  action = $("#question_action")

  if action.length > 0
    url = "/questions/#{action.data('question')}"
    type = "PATCH"
  else
    url = "/questions"
    type = "POST"

  $.ajax url,
    type: type
    data: $(".question_form").serialize()
    success: (data)->
      if action.length > 0
        window.location.href = "/questions/#{action.data('question')}"
      else
        window.location.href = "/"
    error: (error) ->
      console.log error
      object = error.responseJSON
      $.each(object, (key, value)->
        $(".question_form #question_#{key}").addClass("error").parent().append("<div class='error-text'>#{value[0]}</div>")
      )
  )


signInQuestion = (button)->
  question = button.data("question")
  $.ajax "/questions/#{question}/sign_in_question",
    type: "POST"
    success: (response, request) ->
      showMessage(response.message)
    error: (response, request)->
      showMessage(response.error)

complainQuestion = (button) ->
  question = $(button).data("question")
  $.ajax "/questions/#{question}/complaints",
    type: "POST"
    data: {complaint: {complaintable_id: question, complaintable_type: "Question" } }
    success: (response, request) ->
      text = "<div class='complain_message'><%= I18n.t('share.compliant.text') %></div>"
      showMessage(text)


showMessage = (text) ->
  $("body").prepend JST["templates/modal"]
  $("#messageModal .modal-body").html(text)
  $("#messageModal").modal('show')

questionFilter = (button) ->
  order = $(button).attr("order")
  filter = $(button).attr("filter")
  $("span.badge").remove() if filter == "new"
  if $(".question-filters li.active").find("a").attr("filter") == filter
    if($(button).attr("order") == "desc")
      $(button).attr("order", "asc")
      $(button).removeClass("glyphicon-chevron-down").addClass("glyphicon-chevron-up")
    else
      $(button).attr("order", "desc")
      $(button).removeClass("glyphicon-chevron-up").addClass("glyphicon-chevron-down")
  else
    $(".question-filters li.active").removeClass("active")
    $(button).parent().addClass("active")
    $(".question-filters a").removeClass("glyphicon glyphicon-chevron-down glyphicon-chevron-up")
    $(button).addClass("glyphicon glyphicon-chevron-down")
    $(button).attr("order", "desc")
  $.ajax "/questions/filter",
    type: "POST"
    data: {filter: filter, order: order}
    success: (response, request) ->
      $(".question-page-content .questions-list").remove()
      $(".question-page-content").append(response)
    error: (response, request)->
      console.log response
      console.log request