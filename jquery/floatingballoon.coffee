# Insert in the JQuery namespace
$.fn.floatingballoon = (options) ->
    data_name = "_floatingballoon"
    # Return elements to preserve chaining
    # note it would be implicitly returned anyway
    return this.each ->
        el = $(this)
        if el.data(data_name)?
            _data = el.data(data_name)
            _data.update_options(options)
            _data.render()
        else
            _data = new FloatingBalloon(el, options)
            el.data(data_name, _data)

class FloatingBalloon
    constructor: (el, options) ->
        @el = el
        @swingwidth = 50
        @inittop = $(window).height()
        @initleft = Math.random() * $(window).width()
        console.log @inittop, @initleft
        @addtop = 0
        @lefttheta = 2 * Math.PI * Math.random()
        @el.html("<img src='/img/balloon.png' />").css("top", @inittop).css("left", @initleft)
        _this = this
        setInterval((() -> _this.move()), 50)

    move: ->
        @addtop -= 1
        @lefttheta += 0.01
        @el.css("top", @inittop + @addtop).css("left", @initleft + @swingwidth * Math.sin(@lefttheta))
        
