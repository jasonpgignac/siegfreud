class Stage < ActiveRecord::Base
  has_many :available_stage_transitions, :foreign_key => :source_id, :class_name => 'StageTransition'
  has_many :available_stages, :through => :available_stage_transitions, :source => :destination
  validates_presence_of :name
  validates_inclusion_of :has_location, :has_deployment, :is_transitory, :in => [true, false]
  
  def valid_change?(destination)
    available_stages.exists?(destination)
  end
end
