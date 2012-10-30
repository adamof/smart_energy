class EnergyRecord < ActiveRecord::Base
  belongs_to :household
  attr_accessible :household, :usage, :period_end

  scope :within_range, lambda {  }

  def self.get_readings_for(from, to)
    @readings = where("period_end >= ? AND period_end <= ?", from, to).order("period_end")
    return @readings.map{|r| r.usage}
  end
end