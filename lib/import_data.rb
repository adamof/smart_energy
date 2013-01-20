module ImportData
  def self.delete_data
    Household.delete_all
    Record.delete_all
  end
  def self.init(n=nil)
    self.delete_data
    self.import_usage("readings.xls", n)
  end
  def self.import_usage(file, n_households=0)
    s = Excel.new(file)
    last_record = nil
    2.upto(s.last_row) do |line|
      household = s.cell(line,'A')
      amount     = s.cell(line,'B')
      date      = s.cell(line,'C')
      puts "#{line}: #{household}, #{amount}, #{date}"
      household = Household.find_or_create_by_name(household)
      if Household.count==n_households+1
        household.delete
        break
      end
      distribution = (rand(3) + 4).to_f
      this = Record.create household: household, 
                              amount: (10 - distribution)*amount/10,
                              period_end: date.asctime
      if last_record and last_record.household == household
        if this.period_end - last_record.period_end > 3600
          last_record = Record.create household: household, 
                              amount: (amount + last_record.amount)/2.0,
                              period_end: date-1.hour
        end
        Record.create household: household, 
                            amount: distribution*amount/10,
                            period_end: date-30.minutes
      end
      last_record = this
    end
  end
  def fix_data
    
  end
  def self.import_intensities
    CarbonRecord.delete_all
    CSV.foreach("intensities.2011.csv", headers: false) do |r|
      CarbonRecord.create!( period_end: DateTime.strptime(r[0], "%Y/%m/%d %H:%M"),
                            amount: r[1] )
    end
  end
  def self.refresh_intensities
    Record.each do |r|
      r.save!
    end
  end
end
