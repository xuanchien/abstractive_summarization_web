class SummarizationService
	SERVICE_URL = "http://localhost:9999/ws/as"
	REMOTE_METHOD_NAME = "summarize_text"
	def summarize(text, max_words = 100)
		# create a client for the service
		client = Savon.client(wsdl: "#{SERVICE_URL}?wsdl")

		response = client.call(REMOTE_METHOD_NAME.to_sym, message: {arg0: text, arg1: max_words})

		summary_sentences = response.body[:summarize_text_response][:return]

		if summary_sentences.nil?
			return []
		end
		if summary_sentences.is_a?(Hash)
			summary_sentences = [summary_sentences[:item]]
		else
			summary_sentences = summary_sentences.map{|x| x[:item]}
		end

		summary_sentences
	end
end