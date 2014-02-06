jQuery ->	
  $("[class^=\"outer\"] > ul, div.no-js").toggleClass "no-js js"
  $("[class^=\"outer\"] .js ul").hide()
  $("a.clicker").click (e) ->
    if $("div[class^=\"outer\"]").not($(this)).is(':visible')
      $("div[class^=\"outer\"]").not($(this)).slideUp()
      $("a.clicker, .menu-bg").removeClass "active"
    $(this).next("div[class^=\"outer\"]").slideToggle 200
    $(".menu-bg").toggleClass "active"
    $(this).toggleClass "active"
    e.stopPropagation()
    return

  $(document).click ->
    if $("div[class^=\"outer\"]").is(":visible")
      $("div[class^=\"outer\"]", this).slideUp()
      $("a.clicker, .menu-bg").removeClass "active"
    return

  return