class BundleMember < ActiveRecord::Base
  belongs_to :bundle
  belongs_to :package
end
