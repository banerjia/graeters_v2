class ApplicationRecord < ActiveRecord::Base
  skip_before_action :verify_authenticity_token
  
  primary_abstract_class
end
