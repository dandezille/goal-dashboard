module SignInRequestHelpers
  def sign_in
    sign_in_as create(:user)
  end

  def sign_in_as(user)
    @current_user = user
    post session_path,
         params: {
           session: {
             email: @current_user.email, password: @current_user.password
           }
         }
  end

  def current_user
    @current_user
  end
end
