class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :menu
      t.string :name
      t.string :email
      t.string :phone
      t.string :address
      t.string :order_code
      t.string :order_status

      t.timestamps null: false
    end
  end
end
