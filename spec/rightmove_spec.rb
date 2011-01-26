require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rightmove do
	context "manipulating the file" do
		before :all do
			@rm = Rightmove::Archive.new
		end
	
		it "should open the zip file and return useful data" do
		  @rm.should respond_to(:open)
		  @rm.open(File.dirname(__FILE__) + "/rightmove/example.zip", :instantiate_files => true).should be_a(BLM::Document)
		end
		
		it "should return images as StringIO objects" do
			@rm.document.data.first.media_image_00.should be_a(StringIO)
		end
	end
end
