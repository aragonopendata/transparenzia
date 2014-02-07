$ ->

  $("[class^=\"outer\"] > ul, div.no-js").toggleClass "no-js js"
  $("[class^=\"outer\"] .js ul").hide()
  listContainer = "div[class^=\"outer\"]"

  $("a.clicker").click (e) ->
    # hide any open menus
    if $(listContainer).not($(this).next(listContainer)).is(":visible")
      $("a.clicker").not($(this).next(listContainer)).next(listContainer).stop(true, true).hide()
      $("a.clicker").not($(this)).removeClass "active"
      $(".menu-bg").removeClass "active"
    # slide current dropdown menu up or down
    $(this).next(listContainer).stop(true, true).slideToggle 100
    $(this).toggleClass "active"
    $(".menu-bg").toggleClass "active"
    e.stopPropagation()
    return
  # hide any dropdown menu when clicking outside of it
  $(document).click ->
    if $(listContainer).is(":visible")
      $(listContainer).hide()
      $("a.clicker, .menu-bg").removeClass "active"
    return

  return