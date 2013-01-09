class CarbonIntensity < ActiveRecord::Base
  def self.for(date)
    self.find_by_period(date.beginning_of_month).value
  end
end