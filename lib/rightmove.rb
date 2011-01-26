require 'zip/zipfilesystem'
require 'blm'

module Rightmove
	class Archive
		@@configuration = {
			:tmp_dir => "/tmp/rightmove/"
		}
		
		def initialize(file = nil, options = {})
			open(file) unless file.nil?
			@@configuration.update(options)
		end
	
		def open(file, arguments)
			return false unless File.exists?(file)
			@file = file
			read(arguments)
		end
	
		def document
			@document
		end
	
		private
		def read(arguments)
			Zip::ZipFile.open(@file) do |zip|
				@zip_file = zip
				blm = @zip_file.entries.select! {|v| v.to_s =~ /\.blm/i }.first
				@document = BLM::Document.new( zip.read(blm) )
				instantiate_files if arguments[:instantiate_files]
			end
			@document
		end
		
		def instantiate_files
			@document.data.each_with_index do |row, index|
				row.attributes.each do |key, value|
					next unless value =~ /\.jpg/i
					matching_files = @zip_file.entries.select! {|v| v.to_s =~ /#{value}/ }
					unless matching_files.empty?
						file = StringIO.new( @zip_file.read(matching_files.first) )
						file.class.class_eval { attr_accessor :original_filename, :content_type }
						file.original_filename = matching_files.first.to_s
						file.content_type = "image/jpg"
						@document.data[index].attributes[key] = file
					end
				end
			end
		end
	end
end
