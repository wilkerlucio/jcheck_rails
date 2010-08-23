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
      it "should generate jcheck" do
        m = mock_model do
          attr_accessor :number
          
          validates_numericality_of :number
        end
        
        jcheck(m, :number).should == "{'numericality': {'only_integer': false, 'allow_nil': false}}"
      end
      
      it "should accept the only_integer parameter" do
        m = mock_model do
          attr_accessor :number
          
          validates_numericality_of :number, :only_integer => true
        end
        
        jcheck(m, :number).should == "{'numericality': {'only_integer': true, 'allow_nil': false}}"
      end
      
      [:greater_than, :greater_than_or_equal_to, :equal_to, :less_than, :less_than_or_equal_to].each do |parameter|
        it "should accept #{parameter} parameter" do
          m = mock_model do
            attr_accessor :number

            validates_numericality_of :number, parameter => 10
          end

          jcheck(m, :number).should == "{'numericality': {'only_integer': false, 'allow_nil': false, '#{parameter}': 10}}"
        end
      end
      
      [:odd, :even].each do |type|
        it "should accept #{type}" do
          m = mock_model do
            attr_accessor :number

            validates_numericality_of :number, type => true
          end

          jcheck(m, :number).should == "{'numericality': {'only_integer': false, 'allow_nil': false, '#{type}': true}}"
        end
      end
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
    
    it "should not generate for other validations" do
      m = mock_model do
        attr_accessor :name
        validates_presence_of :name
        validates_sample_of :name
      end
      
      jcheck(m, :name).should == "{'presence': true}"
    end
  end
  
  context "i18n" do
    context "field names" do
      it "should get result of humanized attribute" do
        m = mock_model do
          def self.human_attribute_name(attribute)
            attribute == "name" ? "Nome" : attribute.to_s.humanize
          end
        end
        
        JcheckRails::jcheck_attribute_name(m, "name").should == "Nome"
        JcheckRails::jcheck_attribute_name(m, "other").should == "Other"
      end
      
      it "should generate field names for attributes with validations" do
        m = mock_model do
          attr_accessor :name, :email, :main_address
          
          validates_presence_of :name, :main_address
        end
        
        T = m.class
        
        output = jcheck(m)
        output.should include("validator.field('name').custom_label = 'Name'", "validator.field('main_address').custom_label = 'Main address'")
        output.should_not include("validator.field('email')")
      end
      
      it "should not generate field names if it's disabled by option" do
        m = mock_model do
          attr_accessor :name, :email, :main_address
          
          validates_presence_of :name
        end
        
        T2 = m.class
        
        output = jcheck(m, nil, :generate_field_names => false)
        output.should_not include("validator.field('name').custom_label = 'Name'")
      end
    end
  end
  
  context "generating all script for model" do
    before :all do
      @m = mock_model do
        attr_accessor :name
        
        validates_presence_of :name
      end
      
      SampleModel = @m.class
    end
    
    it "should generate all data" do
      jcheck(@m).should == "<script type=\"text/javascript\"> jQuery(function() { var validator = jQuery('#new_sample_model').jcheck({'field_prefix': 'sample_model'}); validator.validates('name', {'presence': true}); validator.field('name').custom_label = 'Name'; }); </script>"
    end
    
    context "filtering attributes" do
      before :all do
        @md = mock_model do
          attr_accessor :name, :email, :address
          
          validates_presence_of :name, :email, :address
        end
        
        FilterTest = @md.class
      end
      
      it "should get only some attributes if using only_attributes option" do
        output = jcheck(@md, :only_attributes => [:name, :email])
        output.should include("validates('name'", "validates('email'")
        output.should_not include("validates('address'")
      end
      
      it "should exclude some attributes if it's sent" do
        output = jcheck(@md, :exclude_attributes => [:name, :address])
        output.should include("validates('email'")
        output.should_not include("validates('name'", "validates('address'")
      end
    end
    
    it "should be able to customize form id" do
      jcheck(@m, :form_id => "custom_form_id").should include("jQuery('#custom_form_id')")
    end
    
    it "should be able to customize field prefix" do
      jcheck(@m, :field_prefix => "custom_field_prefix").should include("'field_prefix': 'custom_field_prefix'")
    end
    
    it "should be able to add custom values" do
      jcheck(@m, :notifiers => ["custom_notifier"], :prevent_submit => false).should include("'notifiers': ['custom_notifier']", "'prevent_submit': false")
    end
    
    it "should be able customize javascript variable name" do
      jcheck(@m, :variable => "v").should include("var v = jQuery", "v.validates")
    end
  end
  
  context "custom validations" do
    it "should ignore validations made with validate" do
      m = mock_model do
        attr_accessor :name
        
        validates_presence_of :name
        validate :something
        
        def something
          errors.add(:name, "some message")
        end
        
        def to_key
          nil
        end
      end
      
      CusCla = m.class
      
      jcheck(m, :generate_field_names => false).should == "<script type=\"text/javascript\"> jQuery(function() { var validator = jQuery('#new_cus_cla').jcheck({'field_prefix': 'cus_cla'}); validator.validates('name', {'presence': true});  }); </script>"
    end
  end
end
