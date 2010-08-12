require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "JcheckRails" do
  context "rails validators" do
    context "format validator" do
      it "should generate jcheck validator" do
        m = mock_model do
          attr_accessor :name
          validates_format_of :name, :with => /^[a-z]regex$/i
        end
        
        jcheck(m).should include("validator.validates('name', {'format': {'with': /^[a-z]regex$/i}});")
      end
      
      it "should work with 'without' option" do
        m = mock_model do
          attr_accessor :name
          validates_format_of :name, :without => /^[a-z]regex$/i
        end
        
        jcheck(m).should include("validator.validates('name', {'format': {'without': /^[a-z]regex$/i}});")
      end
    end
    
    context "presence validator" do
      it "should generate correct jcheck validation" do
        m = mock_model do
          attr_accessor :name
          validates_presence_of :name
        end
        
        jcheck(m).should include("validator.validates('name', {'presence': true});")
      end
    end
  end
end
