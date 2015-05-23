$ ->
  $(".search-text").on "keyup", ->
    if $(this).val() == ""
      $(".search-popup").remove()
    else
      $.ajax "/search",
        type: "GET"
        data: {query: $(this).val()}
        success: (request, response)->
          console.log request
          console.log response
          $(".search-popup ul").html("")
          if $(".search-popup").length == 0
            $(".search-form").append("<div class='search-popup'><ul></ul></div>")

          if request.search.length == 0
            $(".search-popup ul").append("<li class='empty-list'>#{I18n.t("share.search.empty")}</li>")

          for object in request.search.slice(0, 9)
            $(".search-popup ul").append("<li>" +
              "<a href=\"/questions/#{object.id}\" class=\"question-icon\">#{object.text.substring(0, 25)}</a></li>")

          if request.search.length > 10
            $(".search-popup ul").append("<li class='show-all-search'><a>#{I18n.t("share.search.all_result")}</a></li>")
            linkToFullSearchPath($(".search-popup ul li.show-all-search a"))
        error: (request, response) ->
          console.log request
          console.log response

  $(".full-search-submit").click (event) ->
    event.preventDefault()
    event.stopPropagation()
#    alert "1"
    query = $(".full-search-text").val()
    full_list = true
    window.location.href = "/search?query=#{query}&full_list=true"


linkToFullSearchPath = (link) ->
 link.on "click", ->
   query = $(".search-text").val()
   full_list = true
   window.location.href = "/search?query=#{query}&full_list=true"

   $.ajax "/search",
     type: "GET"
     data: {query: query, full_list: full_list}
     success: (request, response)->
#       window.location.href = "/search"
     error: (request, response) ->
       console.log request
       console.log response
