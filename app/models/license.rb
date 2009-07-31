class License < ActiveRecord::Base
  belongs_to :package
  belongs_to :computer
  
  def short_name
    package.short_name
  end
end
