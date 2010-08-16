require 'jcheck_rails/encoder'

module JcheckRails
  extend self
  
  def jcheck_for(object, attribute = nil, options = {})
    return jcheck_for_object_attribute(object, attribute) if attribute
    
    options.reverse_merge!(
      :variable => "validator",
      :form_id => ActionController::RecordIdentifier.dom_id(object, (object.respond_to?(:persisted?) && object.persisted? ? :edit : nil)),
      :field_prefix => ActiveModel::Naming.singular(object)
    )
    
    variable = options.delete :variable
    form_id = options.delete :form_id
    
    validations = []
    
    object.class._validators.each do |attribute, validators|
      attr_validations = jcheck_for_object_attribute(object, attribute)
      
      validations << "#{variable}.validates(#{Encoder.convert_to_javascript attribute}, #{attr_validations});"
    end
    
    %{<script type="text/javascript"> jQuery(function() { var #{variable} = jQuery('##{form_id}').jcheck(#{Encoder.convert_to_javascript(options)}); #{validations.join(" ")} }); </script>}.html_safe
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

ActionView::Base.send :include, JcheckRails
