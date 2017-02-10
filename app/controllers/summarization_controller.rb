class SummarizationController < ApplicationController
  def create
  	original_text = params[:text]
  	summary_sentences = summarization_service.summarize(original_text)
  	render :json => {:sentences => summary_sentences}
  rescue Exception => e
  	render :json => {message: e.message}, :status => 500
  end

  private
  def summarization_service
  	@summarization_service ||= SummarizationService.new
  end
end
