require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "JcheckRails" do
  context "rails validators" do
    context "format validator" do
      it "should generate jcheck validator" do
        f = mock_model do
          attr_accessor :name
          validates_format_of :name, :with => /^[a-z]regex$/i
        end
        
        jcheck(f).should include('validator.validates("name", {"format": {"with": /^[a-z]regex$/i}});')
      end
    end
    
    context "presence validator" do
      it "should generate correct jcheck validation" do
        p = mock_model do
          attr_accessor :name
          validates_presence_of :name
        end
        
        jcheck(p).should include('validator.validates("name", {"presence": true});')
      end
    end
  end
end
