class SummarizationController < ApplicationController
  def create
  	original_text = params[:text]
  	summary_text = summarization_service.summarize(original_text)
  	render :json => {:content => summary_text}
  rescue Exception => e
  	render :json => {message: e.message}, :status => 500
  end

  private
  def summarization_service
  	@summarization_service ||= SummarizationService.new
  end
end
