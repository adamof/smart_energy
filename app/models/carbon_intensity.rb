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
    if record = self.find_by_period(date.beginning_of_hour)
      return record.value
    else
      return self.where("month(period) = #{date.month}").group("month(period)").average(:value).values.last.to_f.round(2)
    end
  end
end