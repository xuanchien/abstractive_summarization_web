window.StringUtils = {};

StringUtils.countWords = (text) ->
	matches = text.match(/\W+/g)
	if matches then matches.length else 0

StringUtils.countCharacters = (text) ->
	text.length

StringUtils.countSentences = (text) ->
	text.split("\n").length