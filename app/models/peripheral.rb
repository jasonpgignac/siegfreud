class Peripheral < ActiveRecord::Base
  belongs_to :computer
  define_index do
    indexes serial_number
    indexes model
    set_property :delta => true
  end
  
  def short_name
    self.model + self.serial_number
  end
end
