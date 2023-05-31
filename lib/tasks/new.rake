namespace :admin do
  task :new => :environment do
    print "enter first name: "
    first = get_input
    print "enter last name: "
    last = get_input
    print "enter email address: "
    email = get_input
    print "enter password: "
    password = get_input
    print "confirm password: "
    confirm = get_input
    
    user = User.new(first_name: first, last_name: last, email: email,
        password: password, password_confirmation: confirm, is_admin: true, 
        verified_at: Time.now)
    
    if user.save
      p "admin created"
    else
      p user.errors.full_messages.to_sentence
    end
  end

  def get_input
    STDIN.gets.chomp
  end
end