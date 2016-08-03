class OrderSerializer < ActiveModel::Serializer

  attributes :id, :menu, :name, :email, :phone, 
  		:address, :order_code, :order_status
end  