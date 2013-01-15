class PowerRecord < Record
  before_save :calc_carbon#, :if => :amount_changed?

  def calc_carbon
    self.carbon_intensity = PowerIntensity.for(self.period_end)
    self.carbon_result = (self.carbon_intensity * self.amount)/1000.0
  end  
end