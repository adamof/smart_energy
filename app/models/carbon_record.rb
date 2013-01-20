class CarbonRecord < Record
  def self.for(date)
    if record = self.find_by_period_end(date.beginning_of_hour)
      return record.amount
    else
      return self.where("month(period_end) = #{date.month}").group("month(period_end)").average(:amount).values.last.to_f.round(2)
    end
  end
end