class AuthenticationController < ApplicationController
  skip_before_action :authenticate


  # POST /signup
  def signup
    user = User.new(user_params)

    if user.save
      token = JsonWebToken.encode(id: user.id)
      expires_at = JsonWebToken.decode(token)[:exp]

      render json: { data: user, token: token, expires_at: expires_at }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /login
  def login
    user = User.find_by(email: params[:email].downcase)
    authenticated_user = user&.authenticate(params[:password])

    if authenticated_user
      token = JsonWebToken.encode(id: user.id)
      expires_at = JsonWebToken.decode(token)[:exp]

      render json: { data: user, token:, expires_at: }, status: :ok
    else
      render json: { error: "unauthorized" }, status: :unauthorized
    end
  end

  # DELETE /logout
  def logout
    # For a stateless JWT-based authentication, logout is handled client-side by deleting the token
    # Here, we simulate logout by sending a success message
    render json: { message: "Logged out successfully" }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :address, :password, :password_confirmation)
  end
end
