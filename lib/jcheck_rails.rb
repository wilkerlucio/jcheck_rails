require 'jcheck_rails/encoder'

module JcheckRails
  class << self
    def jcheck_for(object)
      validations = []
      
      object.class._validators.each do |attribute, validators|
        attr_validations = []

        validators.each do |validator|
          attr_validations << "#{Encoder.convert_to_javascript validator.kind}: #{Encoder.convert_to_javascript(validator.options)}"
        end
        
        validations << "validator.validates(#{Encoder.convert_to_javascript attribute}, {#{attr_validations.join(", ")}});"
      end
      
      <<-EOS
<script type="text/javascript">
  var validator = $("form").jcheck();
  #{validations.join("\n")}
</script>
EOS
    end
  end
end