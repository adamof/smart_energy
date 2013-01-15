class CarbonIntensity < ActiveRecord::Base
  # def self.for(date, unit = "kilowatt-hour")
  #   case unit
  #   when "watt-hour"
  #     self.find_by_period(date.beginning_of_month).value/1000
  #   when "kilowatt-hour"
  #     self.find_by_period(date.beginning_of_month).value/1000
  #   when "megawatt-hour"
  #     self.find_by_period(date.beginning_of_month).value/1000
  #   end
  # end
  def self.for(date)
    self.find_by_period(date.beginning_of_month).value
  end
end