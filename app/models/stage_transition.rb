class StageTransition < ActiveRecord::Base
  belongs_to :source, :class_name => 'Stage' 
  belongs_to :destination, :class_name => 'Stage'
  validates_presence_of :source, :destination
end
