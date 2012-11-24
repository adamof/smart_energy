class EnergyRecord < ActiveRecord::Base
  belongs_to :household
  attr_accessible :household, :usage, :period_end
end