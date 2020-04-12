module SignInRequestHelpers

  def sign_in_as(user)
    post session_path, params: { session: { email: user.email, password: user.password } }
  end
end