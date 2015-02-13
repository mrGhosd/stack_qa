$ ->
#  $(document).on('ajaxStart', ->
#    console.log "1"
#  ).on('ajaxSuccess', ->
#    console.log "2"
#  )
  gif = $("<img src='/assets/ajax-loader.gif' class='js-ajax-load-image'/>")
#  $("body").after(gif)
  $(document).ajaxStart ->
    $("body").css("opacity", 0.5)
    $(".add-answer").after(gif)
  $(document).ajaxComplete ->
    $("body").css("opacity", 1)
    gif.remove()
    console.log "2"
#  $('#loading-image').bind('ajaxStart', function(){
#  $(this).show();
#}).bind('ajaxStop', function(){
#$(this).hide();
#});