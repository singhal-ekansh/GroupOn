namespace :admin do
  task :new => :environment do
    p "enter first name"
    first = STDIN.gets.chomp
    p "enter last name"
    last = STDIN.gets.chomp
    p "enter email address"
    email = STDIN.gets.chomp
    p "enter password"
    password = STDIN.gets.chomp
    p "confirm password"
    confirm = STDIN.gets.chomp
    
    u = User.create(first_name: first, last_name: last, email: email,
        password: password, password_confirmation: confirm, is_admin: true, 
        verified_at: Time.now)
    
    if u.persisted?
      p "admin created"
    else
      p u.errors.to_a
    end
  end

end