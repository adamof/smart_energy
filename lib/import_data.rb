module ImportData
  def self.import_usage(file)
    s = Excel.new(file)
    2.upto(s.last_row) do |line|
      household = s.cell(line,'A')
      usage     = s.cell(line,'B')
      date      = s.cell(line,'C')
      puts "#{line}: #{household}, #{usage}, #{date}"
      household = Household.find_or_create_by_name(household)
      EnergyRecord.create  household: household, 
                          usage: usage,
                          period_end: date.asctime
    end
  end
  def fix_data
    
  end
end
