namespace :admin do
  task :category_seed => :environment do 
    Category.destroy_all
    Category.create(name: 'Food')
    Category.create(name: 'Travel')
    Category.create(name: 'Fashion')
    Category.create(name: 'Electronics')
    Category.create(name: 'Entertainment')
  end
end