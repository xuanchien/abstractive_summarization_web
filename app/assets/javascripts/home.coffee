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
				summary = $.trim(response.content)
				$('#progress_bar').hide()
				$('#summary_text').text(summary)
				$('#generate_summary_button').prop('disabled', false)
			error: (xhr, textStatus, error) ->
				$('#summary_text').text("Error while processing your request. Please contact the admin")


				words = StringUtils.countWords(summary)
				characters = StringUtils.countCharacters(summary)
				sentences = StringUtils.countSentences(summary)

				updateStats(words, characters, sentences)

	$('#original_text_area').on 'change input keyup propertychange paste', (e) ->
		originalText = $('#original_text_area').val()
		words = StringUtils.countWords(originalText)
		characters = StringUtils.countCharacters(originalText)
		sentences = StringUtils.countSentences(originalText)
		updateStats(words, characters, sentences, true)