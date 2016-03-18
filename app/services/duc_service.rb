class DucService
	YEAR = 2004
	def document_sets
		doc_sets = Dir.entries(File.join(data_path, "testdata"))

		return filter_out_hidden_files(doc_sets)
	end

	def details(doc_set_id)
		return list_news(doc_set_id), summary(doc_set_id)
	end

	def list_news(doc_set_id)
		path = File.join(data_path, "testdata", doc_set_id)

		news_files = Dir.entries(path)

		news_files = filter_out_hidden_files(news_files)

		news_content = {}

		news_files.each do |file|
			news_content[file] = File.read(File.join(path, file))
		end

		news_content
	end

	def summary(doc_set_id)
		path = File.join(data_path, "summary", "#{doc_set_id}_system.txt")

		return File.read(path)
	end

	private
	def data_path
		File.join(Rails.root, "duc_data", YEAR.to_s)
	end

	def filter_out_hidden_files(files)
		files.delete_if{|a| a.starts_with?(".")}
	end
end