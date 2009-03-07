class SmsTask < ActiveRecord::Base
  belongs_to :package,
              :class_name => "SmsPackage"
  def to_s
    "SMS Task " + self.remote_id
  end
  
  def remote_id
    name
  end
  def content_id
    remote_id
  end

end
