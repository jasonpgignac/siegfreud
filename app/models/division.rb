class Division < ActiveRecord::Base
  has_many :computers

  def display_name
    "#{name} (#{divisions})"
  end
end
