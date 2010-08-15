require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "JcheckRails" do
  context "rails validators" do
    it "should return blank object if attribute has no validations" do
      m = mock_model do
        attr_accessor :name
      end
      
      jcheck(m, :name).should == "{}"
    end
    
    context "acceptance validator" do
      it "should generate jcheck validator" do
        m = mock_model do
          attr_accessor :terms
          
          validates_acceptance_of :terms
        end
        
        jcheck(m, :terms).should == "{'acceptance': {'accept': '1'}}"
      end
      
      it "should accept a custom acceptance" do
        m = mock_model do
          attr_accessor :terms
          
          validates_acceptance_of :terms, :accept => "3"
        end
        
        jcheck(m, :terms).should == "{'acceptance': {'accept': '3'}}"
      end
    end
    
    context "confirmation" do
      it "should generate jcheck validator" do
        m = mock_model do
          attr_accessor :password, :password_confirmation
          
          validates_confirmation_of :password
        end
        
        jcheck(m, :password).should == "{'confirmation': true}"
      end
    end
    
    context "exclusion" do
      it "should generate jcheck validator" do
        m = mock_model do
          attr_accessor :login
          
          validates_exclusion_of :login, :in => ["admin", "bot"]
        end
        
        jcheck(m, :login).should == "{'exclusion': {'in': ['admin', 'bot']}}"
      end
    end
    
    context "format validator" do
      it "should generate jcheck validator" do
        m = mock_model do
          attr_accessor :name
          validates_format_of :name, :with => /^[a-z]regex$/i
        end
        
        jcheck(m, :name).should == "{'format': {'with': /^[a-z]regex$/i}}"
      end
      
      it "should work with 'without' option" do
        m = mock_model do
          attr_accessor :name
          validates_format_of :name, :without => /^[a-z]regex$/i
        end
        
        jcheck(m, :name).should == "{'format': {'without': /^[a-z]regex$/i}}"
      end
    end
    
    context "inclusion validator" do
      it "should generate jcheck validator" do
        m = mock_model do
          attr_accessor :civil_state
          
          validates_inclusion_of :civil_state, :in => ["single", "married"]
        end
        
        jcheck(m, :civil_state).should == "{'inclusion': {'in': ['single', 'married']}}"
      end
    end
    
    context "length validator" do
      it "should generate jcheck with is" do
        m = mock_model do
          attr_accessor :message
          
          validates_length_of :message, :is => 10
        end
        
        jcheck(m, :message).should == "{'length': {'is': 10}}"
      end
      
      it "should generate jcheck with minimum" do
        m = mock_model do
          attr_accessor :message
          
          validates_length_of :message, :minimum => 10
        end
        
        jcheck(m, :message).should == "{'length': {'minimum': 10}}"
      end
      
      it "should generate jcheck with maximum" do
        m = mock_model do
          attr_accessor :message
          
          validates_length_of :message, :maximum => 10
        end
        
        jcheck(m, :message).should == "{'length': {'maximum': 10}}"
      end
      
      it "should generate jcheck with minimum and maximum" do
        m = mock_model do
          attr_accessor :message
          
          validates_length_of :message, :minimum => 2, :maximum => 10
        end
        
        jcheck(m, :message).should == "{'length': {'minimum': 2, 'maximum': 10}}"
      end
    end
    
    context "numericality validator" do
      
    end
    
    context "presence validator" do
      it "should generate correct jcheck validation" do
        m = mock_model do
          attr_accessor :name
          validates_presence_of :name
        end
        
        jcheck(m, :name).should == "{'presence': true}"
      end
    end
  end
end
