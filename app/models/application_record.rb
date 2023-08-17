class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  VALID_DATE_REGEX = /\A[1-9]\d{3}-\d{2}-\d{2}\z/
  # VALID_TIME_REGEX = /\A\d{1,2}:\d{1,2}:\d{1,2}\z/
end
