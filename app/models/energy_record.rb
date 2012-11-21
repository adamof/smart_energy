class EnergyRecord < ActiveRecord::Base
  belongs_to :household
  attr_accessible :household, :usage, :period_end

  scope :within_range, lambda {  }

  # def self.get_readings_for(from, to, unit="day")
  #   @readings = where("period_end >= ? AND period_end <= ?", from, to).order("period_end")
  #   # res = @readings.map{|r| r.usage}
  #   return @readings.group_by{ |u| u.period_end.beginning_of_day }.map {|k,v| v.map{|r| r.usage}.sum}
  # end
end