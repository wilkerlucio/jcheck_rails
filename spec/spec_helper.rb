$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'jcheck_rails'
require 'rspec'

require 'active_model'

def jcheck(*args)
  JcheckRails.jcheck_for(*args)
end

def mock_model(&block)
  cls = Class.new
  cls.send :include, ActiveModel::Validations
  cls.class_eval &block
  cls.new
end
