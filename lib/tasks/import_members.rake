desc "Import members from /tmp/members.csv." 
task :import_members => :environment do
  require 'csv'
  CSV.foreach("/tmp/members.csv", encoding: 'utf-8') do |row|
    id, name, year, cls, phone, email, gender, qq, birthday, dept, ss = row
    name.force_encoding('utf-8')
    puts name
    p = {}
    p[:name] = name
    p[:admission_year] = year
    p[:class_number] = cls
    p[:phone_number] = phone
    p[:email] = email
    if gender == 'M'
      puts 'M'
      p[:gender] = 1
    elsif gender == 'F'
      puts 'F'
      p[:gender] = 2
    else
      puts 'Shouldn\'t happen. '
    end
    p[:qq] = qq
    if birthday and !birthday.empty?
      y, m, d = birthday.split('.')
      p[:birthday] = Date.new(y.to_i, m.to_i, d.to_i)
    else
      puts "Birthday skipped. "
      p[:birthday] = nil
    end
    p[:department_id] = dept
    p[:secondary_school] = ss
    p[:code_number] = id
    p[:memo] = ''
    user = Member.new(p)
    if !user.valid?
      user.errors.full_messages.each do |msg|
        puts msg
      end
    else
      user.save
    end
  end
end
