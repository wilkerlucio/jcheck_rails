require 'jcheck_rails/encoder'

module JcheckRails
  class << self
    def jcheck_for(object, attribute = nil)
      return jcheck_for_object_attribute(object, attribute) if attribute
      
      validations = []
      
      object.class._validators.each do |attribute, validators|
        attr_validations = jcheck_for_object_attribute(object, attribute)
        
        validations << "validator.validates(#{Encoder.convert_to_javascript attribute}, #{attr_validations.join(", ")});"
      end
      
      %{<script type="text/javascript"> var validator = $("form").jcheck(); #{validations.join(" ")} </script>}
    end
    
    def jcheck_for_object_attribute(object, attribute)
      validations = object.class._validators[attribute].inject([]) do |acc, validator|
        options = filter_validator_options(validator)
        
        acc << "#{Encoder.convert_to_javascript validator.kind}: #{Encoder.convert_to_javascript(options)}"
      end
      
      "{#{validations.join(', ')}}"
    end
    
    protected
    
    def filter_validator_options(validator)
      options = validator.options.dup
      
      case validator.kind
      when :acceptance
        options.delete :allow_nil
      when :length
        options.delete :tokenizer
      end
      
      options
    end
  end
end