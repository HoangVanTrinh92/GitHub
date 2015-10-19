namespace :db do
  desc "Remaking data"
  task remake_data: :environment do

    puts "Creating manager"
    FactoryGirl.create :user

    puts "Creating ranks 1 to 10"
    FactoryGirl.create_list :rank, 10

    puts "Creating positions"
    Settings.data.position.each do |key, value|
      FactoryGirl.create :position, name: value
    end

    puts "Creating titles"
    7.times {FactoryGirl.create :title}

    puts "Creating price periods"
    FactoryGirl.create :period

    puts "Importing groups"
    import = Import.new "#{Rails.root}/lib/assets/groups.json", Group, :id, "group"
    import.save! if import.valid?

    puts "Importing teams"
    import = Import.new "#{Rails.root}/lib/assets/teams.json", Team, :id, "team"
    import.save! if import.valid?

    puts "Importing employees"
    import = Import.new "#{Rails.root}/lib/assets/users.csv", Employee, :email, "employee"
    import.save! if import.valid?

    puts "Importing group employees"
    import = Import.new "#{Rails.root}/lib/assets/group_users.json", GroupEmployee, :id, "group_employee"
    import.save! if import.valid?

    puts "Creating skill"
    ["Ruby", "Android", "IOS", "Python", "PHP"].each do |skill_name|
      FactoryGirl.create :skill, name: skill_name
    end

    puts "Creating salaries, evaluations, evaluation details for employees"
    Employee.all.each do |employee|
      FactoryGirl.create :salary, employee: employee, fixed: true

      FactoryGirl.create :evaluation, employee: employee

      FactoryGirl.create :evaluation_detail,
        employee: employee,
        evaluation_type: 0,
        period: Period.last

      FactoryGirl.create :employee_skill,
        employee: employee,
        skill: Skill.order("RAND()").first
      EvaluationDetail::LIST_EVALUATION_TYPE.each do |evaluation_type|
        FactoryGirl.create :evaluation_detail, employee: employee, evaluation_type: evaluation_type,
          period: Period.last
      end
    end

    puts "Creating projects"
    5.times {FactoryGirl.create :project}

    puts "Completed rake data"
  end
end
