desc "Create a superuser for initial managements. "
task :create_superuser => :environment do
  puts "This script creates a superuser to be used to do initial managements. "
  puts "This script also creates a dummy department to accomodate the superuser. "

  # Create the department

  department = Department.create
  department.name = "Administrators"

  if department.save
    puts "Department creation successful. "
  else
    puts "Department creation failed. "
    puts department.errors.full_messages.join("\n")
  end

  # Create the superuser

  user = Member.create

  user.name = "Superuser"
  user.admission_year = 2011
  user.class_number = 1
  user.phone_number = 10000000000
  user.email = "nobody@nobody.com"
  user.gender = 1
  user.department = department
  user.code_number = 2011000
  user.password = user.password_confirmation = "2011000"
  user.privilege = 100

  if user.save
    puts "Superuser creation successful. "
  else
    puts "Superuser creation failed. "
    puts user.errors.full_messages.join("\n")
  end
end
