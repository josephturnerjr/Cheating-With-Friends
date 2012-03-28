addballoon = () ->
    $("<div class='balloon'></div>").appendTo("body").floatingballoon()

onready = () ->
    $("#cheatmain").cheatwidget()
    on_screen = 4
    pix_per_sec = 1000 / 50
    secs_per_screen = $(window).height() / pix_per_sec
    create_rate = 1000 * secs_per_screen / on_screen
    setTimeout((() -> addballoon()), i * create_rate) for i in [1..on_screen]

$(document).ready(onready)
