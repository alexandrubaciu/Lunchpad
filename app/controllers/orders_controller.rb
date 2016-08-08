class OrdersController < ApplicationController
 def index
 	@orders = Order.all 
 end

 def show
 	@order = Order.find(params[:id])
 end


	def new
		@order = Order.new

 end

 	def destroy
 		@order = Order.find(params[:id])
 		@order.destroy

 		redirect_to orders_path
 	end	

 def edit
 	@order = Order.find(params[:id])
 end


 def create
 	@order = Order.new(order_params)
 	if @order.save
 			UserMailer.delay.new_order(@order)
			redirect_to @order
		else
			render 'new'
		end
 end

 def update
 	@order = Order.find(params[:id])
 	if @order.update(order_params)
 		redirect_to @order
 	else
 		render 'edit'
 	end
 end

 private

 def order_params
 	params.require(:order).permit(:menu_id,:name,:email,:phone,:address,:order_code,:order_status, :user_id)
 end

end
