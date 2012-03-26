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
                        <h2></h2>
                        <p>Enter the word, using any non-alphabet character for an unknown:</p>
                        <input name='word' type='text'></input>
                        <p>Enter any excluded letters (i.e. letters you've tried that weren't in the word):</p>
                        <input name='misses' type='text'></input>
                      </div>
                      <div class='cheat_letters'>
                        <h2>The most likely next letter is:</h2>
                      </div>
                      <div class='cheat_words'>
                        <h2>Possible words:</h2>
                      </div>
                     ")
        @el.append template 
        @word_input = @el.find('input[name="word"]').keyup(=>@handle_word())
        @misses_input = @el.find('input[name="misses"]').keyup(=>@handle_word())
        @cheat_words = @el.find('.cheat_words')
        @cheat_letters = @el.find('.cheat_letters')

    handle_word: () ->
        word = @word_input.val().replace(/[^a-zA-Z]/g, '.')
        @word_input.val(word)
        misses = @misses_input.val()
        results = @solver.solve(word, misses.split(""))
        possibilities = results.get_possibilities()
        @draw_words(possibilities)
        @draw_letter_freqs(results.get_letter_freqs(), possibilities.length)

    draw_words: (possibilities) ->
        @cheat_words.html("<h2>Possible words:</h2> 
                           <p>#{possibilities.join(" ")}</p>")

    draw_letter_freqs: (freqs, wordcount) ->
        if freqs.length is 0
            @cheat_letters.html("<h2>The most likely next letter is:</h2>")
        else
            likely_letters = (f[1] for f in freqs when f[0] == freqs[0][0])
            htmltext = "<h2>The most likely next letter#{if likely_letters.length == 1 then " is" else "s are"}:</h2>
                        <h1>#{likely_letters.join(", ")}</h1>
                        <h2>with probability #{(100.0 * freqs[0][0] / wordcount).toFixed(2)}%</h2>"
            @cheat_letters.html(htmltext)
            graph_div = $("<div class='pmchart clearfix'></div>")
            for v in freqs
                [freq, letter] = v
                likelihood = (100.0 * freq) / wordcount
                graph_div.append "<div class='pmcolumn' style='width: #{100.0 / freqs.length}%'>
                                    <div style='bottom: #{likelihood}px'>
                                        <p>#{letter}</p>
                                    </div>
                                    <div class='columndata' style='height: #{likelihood}px;'></div>
                                  </div>"
            graph_div.append "<p>100%</p>"
            @cheat_letters.append(graph_div)

    update_options: (options) ->
        @options = options
