module API  
  module V1
    class Users < Grape::API
      include API::V1::Defaults

      resource :users do
  ## This takes care of parameter validation
        desc "get all users"
        get "", root: :users do
          User.all      
        end
        
        desc "create a new  user"
        params do
          requires :name, type: String
          requires :email, type: String
          requires :password, type:String
          requires :password_confirmation, type: String
          requires :phone, type: String
          requires :address, type: String
        end
  ## This takes care of creating employe

        post "sign_up" do
          User.create!({
            name:params[:name],
            email:params[:email],
            password:params[:password],
            password_confirmation: params[:password_confirmation],
            phone: params[:phone],
            address: params[:address]
          })
        end


        desc "login an user"
        
        params do
          requires :email, type: String
          requires :password, type:String
        end

        post "login" do
          email = params[:email]
          password = params[:password]

          if email.nil? or password.nil?
            error!({error_code: 404, error_message: 'Invalid Email or Password.'}, 401)
            return
          end

          user = User.where(email: email.downcase).first
          if user.nil?
            error!({error_code: 404, error_message: 'Invalid Email or Password.'}, 401)
            return
          end

          if !user.valid_password?(password)
            error!({error_code: 404, error_message: 'Invalid Email or Password.'}, 401)
            return
          else
            user.ensure_authentication_token
            user.save
            {status: 'ok', auth_token: user.authentication_token}
          end
        end

      
      end

    end
  end
end  