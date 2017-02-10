# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
	updateStats = (words, characters, sentences, isOnOriginal) ->
		element = ""
		if (isOnOriginal)
			element = "original_"

		$('#' + element + 'word_count').text(words)
		$('#' + element + 'character_count').text(characters)
		$('#' + element + 'sentence_count').text(sentences)

	generateHtmlSummary = (sentence_phrases) ->
		i = 0
		html_text = ''
		while i < sentence_phrases.length
			phrases = sentence_phrases[i]
			np = phrases[0]
			vps = phrases.slice(1)
			html_text = html_text + "<span class='np'>" + np + "</span>"
			vp_html_text = []
			for vp in vps
				vp_html_text.push(" <span class='vp'>" + vp + "</span>")

			html_text += ' ' + vp_html_text.join(', ') + '<br />'

			i++

		return html_text

	switchMode = (mode) ->
		if mode == 'view'
			$('#original_text_view').removeClass('hidden')
			$('#edit_content_button').removeClass('hidden')

			$('#original_text_area').addClass('hidden')
			$('#generate_summary_button').addClass('hidden')
		else
			$('#original_text_view').addClass('hidden')
			$('#edit_content_button').addClass('hidden')

			$('#original_text_area').removeClass('hidden')
			$('#generate_summary_button').removeClass('hidden')

	$("#generate_summary_button").click (e) ->
		originalText = $('#original_text_area').val()
		$.ajax
			url: '/summarization'
			type: 'POST'
			dataType: 'JSON'
			data:
				text: originalText
			beforeSend: ->
				$('#summary_text').text("")
				$('#progress_bar').show()
				$('#generate_summary_button').prop('disabled', true)
			success: (response) ->
				summary = $.trim(generateHtmlSummary(response.sentences));
				$('#original_text_view').text(originalText);
				switchMode('view');
				$('#progress_bar').hide()
				$('#summary_text').html(summary)
				$('#generate_summary_button').prop('disabled', false)
				words = StringUtils.countWords(summary)
				characters = StringUtils.countCharacters(summary)
				sentences = StringUtils.countSentences(summary)

				updateStats(words, characters, sentences)

			error: (xhr, textStatus, error) ->
				$('#summary_text').text("Error while processing your request. Please contact the admin")
				$('#generate_summary_button').prop('disabled', false)

	$('#edit_content_button').click (e) ->
		switchMode('edit')

	$(document).on 'click', ".np, .vp", (e) ->
		$('.np, .vp').removeClass('selected')
		$(e.currentTarget).addClass('selected')
		phraseText = $(e.currentTarget).text()
		originalText = $('#original_text_area').val()

		#Do some pre-processing here
		phraseText = phraseText.replace(/\sn\'t/g, "n't").replace(/\s\'s/g, "'s").replace("`` ", '"')
		phraseText = phraseText.replace(/\s,/g, ",")

		start_pos = 0
		while true
			pos = originalText.indexOf(phraseText, start_pos)

			if pos >= 0
				prefixPart = originalText.substring(0, pos)
				highlightPart = "<span class='highlight'>" + phraseText + "</span>"
				suffixPart = originalText.substring(pos + phraseText.length)

				originalText = prefixPart + highlightPart + suffixPart
				start_pos = pos + highlightPart.length
			else
				break

		$('#original_text_view').html(originalText);
		highlightDiv = $('#original_text_view').find('.highlight')
		containerOffsetTop = $('.scrollable').offset().top
		containerScrollTop = $('.scrollable').scrollTop()
		$('.scrollable').scrollTop(highlightDiv.offset().top - containerOffsetTop + containerScrollTop - 40)

	$('#original_text_area').on 'change input keyup propertychange paste', (e) ->
		originalText = $('#original_text_area').val()
		words = StringUtils.countWords(originalText)
		characters = StringUtils.countCharacters(originalText)
		sentences = StringUtils.countSentences(originalText)
		updateStats(words, characters, sentences, true)