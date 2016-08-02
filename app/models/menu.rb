class Menu < ActiveRecord::Base
	 validates :date, presence: true
	 validates :title, presence: true,
                    length: { minimum: 5 }
     validates :first_dish, presence: true,
                    length: { minimum: 5 }
     validates :second_dish, presence: true,
                    length: { minimum: 5 } 
     validates :dessert, presence: true,
                    length: { minimum: 5 }                              
end