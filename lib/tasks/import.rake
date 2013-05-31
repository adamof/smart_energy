task :import => :environment do
  ImportData.init
end

task :create_user => :environment do
  admin = User.create! do |u|
    u.email = 'sample@sample.com'
    u.password = 'password'
    u.password_confirmation = 'password'
    u.household = Household.first
  end
end