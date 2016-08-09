module API  
  module V1
    class Orders < Grape::API
      include API::V1::Defaults

      resource :orders do


        desc "checking code"
        params do
          requires :order_code, type: String
        end

        get :check_code do
          order_code = params[:order_code].split('-')
          order_id = order_code[0]
          menu_id = order_code[1]
        

            begin
                order = Order.where(id: order_id).first
            rescue
                order = nil
            end
            begin
                menu = Menu.where(id: menu_id).first
            rescue
                menu = nil
            end
            if order_id.blank?
              {error_code: 401, error_message:"No order code."}
            elsif menu_id.blank?
              {error_code: 401, error_message:"No menu id."}
            elsif order_id.blank?
              {error_code: 401, error_message:"No order id"}
            else
              { order_id: order.id,
                title: menu.title,
                first_dish: menu.first_dish,
                second_dish: menu.second_dish,
                dessert: menu.dessert,
                order_status: order.order_status}
            end

        end


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

        desc "create a new  order"
        params do
          requires :token, type: String
          requires :menu_id, type: String
        end

        post "new" do
          token = params[:token]
          menu_id= params[:menu_id]
          begin
            user = User.where(authentication_token: token).first!
          rescue
            user = nil
          end
          begin
            menu = Menu.where(id: menu_id).first!
          rescue
            menu = nil
          end
          if token.blank?
            {error_code: 401, error_message:"Not authorized."}
          elsif menu_id.blank?
            {error_code: 401, error_message:"No menu choosen."}
          elsif user.nil?
            {error_code: 401, error_message:"No user found"}
          elsif menu.nil?
            {error_code: 401, error_message:"No menu found for this menu_id."}
          else
            order=Order.create!({
              menu_id: menu_id,
              user_id: user.id,
              order_status: "Pending"
            })
            UserMailer.delay.new_order(order)
            { status: 201, message: "order created" }
          end

        end    

        desc "create rating"
        params do
          requires :rating, type: Integer
          requires :order_id, type: String
          requires :token, type: String
        end

        post "rating" do 
          rating = params[:rating]
          order_id = params[:order_id]
          token = params[:token] 
          begin
            user = User.where(authentication_token: token).first!
          rescue
            user = nil
          end
          begin
            order = Order.where(id: order_id).first!
          rescue
            order = nil
          end
          if token.blank?
            {error_code: 401, error_message:"Not authorized."}
          elsif order_id.blank?
            {error_code: 401, error_message:"No order choosen."}
          elsif user.nil?
            {error_code: 401, error_message:"No user found"}
          else
            order.rating = rating
            order.save
            {success_message: "Rating save"}
          end
        end

      end
    end
  end
end  