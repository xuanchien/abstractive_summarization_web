class DucDataController < ApplicationController
	def index
		year = params[:year] || "2004"

		@doc_sets = duc_service.document_sets
	end

	def show
		doc_set_id = params[:id]

		@news, @summary = duc_service.details(doc_set_id)
	end

	private
	def duc_service
		@duc_service ||= DucService.new
	end
end