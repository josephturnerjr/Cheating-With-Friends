# Insert in the JQuery namespace
$.fn.cheatwidget = (options) ->
    data_name = "_cheatwidget"
    # Return elements to preserve chaining
    # note it would be implicitly returned anyway
    return this.each ->
        el = $(this)
        if el.data(data_name)?
            _data = el.data(data_name)
            _data.update_options(options)
            _data.render()
        else
            _data = new CheatWidget(el, options)
            el.data(data_name, _data)

class CheatWidget
    constructor: (el, options) ->
        @el = el
        @update_options(options)
        $.get('wordlist.txt', @init)

    init: (data, textStatus, jqXHR) =>
        @solver = new Solver(data)
        template = $("
                      <div class='cheat_input'>
                        <input name='word' type='text'></input>
                        <input name='misses' type='text'></input>
                      </div>
                      <div class='cheat_words'></div>
                      <div class='cheat_letters'></div>
                     ")
        @el.append template 
        # Is there a way to access the unbound this in a fat-arrow function?
        _this = this
        @el.find('input[name="word"]').keyup(=>@handle_word())
        @el.find('input[name="misses"]').keyup(=>@handle_word())

    handle_word: () ->
        word = $('input[name="word"]').val()
        misses = $('input[name="misses"]').val()
        results = @solver.solve(word, misses.split(""))
        @el.find('.cheat_words').html("<p>#{results.get_possibilities().join(" ")}</p>")
        @el.find('.cheat_letters').html("<p>#{results.get_letter_freqs().join(" ")}</p>")

    update_options: (options) ->
        @options = options
