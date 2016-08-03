module API  
  module V1
    class Orders < Grape::API
      include API::V1::Defaults

      resource :orders do
        desc "Return all orders"
        get "", root: :orders do
          Order.all
        end

        desc "Return a order"
        params do
          requires :id, type: String, desc: "ID of the 
            order"
        end
        get ":id", root: "order" do
          Order.where(id: permitted_params[:id]).first!
        end
      end
    end
  end
end  