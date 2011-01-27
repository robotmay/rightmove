require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rightmove do
	context "manipulating the file" do
		before :all do
			@rm = Rightmove::Archive.new
			@zip_file = Zip::ZipFile.open(File.dirname(__FILE__) + "/rightmove/rmc_2559_20050908161421.zip")
		end
	
		it "should open the zip file and return useful data" do
		  @rm.should respond_to(:open)
		  @rm.open(@zip_file).should be_a(BLM::Document)
		end
		
		it "should return images as StringIO objects if passed :instantiate_with" do
			@rm.document.data.first.media_image_00(:instantiate_with => @zip_file).should be_a(StringIO)
			@rm.document.data.first.media_image_00.should be_a(String)
		end
		
		it "should provide the branch id and timestamp of the file" do
			@rm.branch_id.should be_a(Integer)
			@rm.timestamp.should be_a(Time)
		end
	end
end
