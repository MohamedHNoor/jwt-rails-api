class ApplicationController < ActionController::API
  before_action :authenticate


  rescue_from JWT::VerificationError, with: :invalid_token
  rescue_from JWT::DecodeError, with: :decode_error

  private

  def authenticate
    authorization_header = request.headers["Authorization"]
    token = authorization_header.split(" ").last if authorization_header
    decoded_token = JsonWebToken.decode(token)

    @current_user = User.find(decoded_token[:id])
  end

  def authenticate_admin
    authenticate
    unless @current_user&.admin?
      render json: { error: "Forbidden: Admins only" }, status: :forbidden
    end
  end

  def invalid_token
    render json: { invalid_token: "invalid token" }
  end

  def decode_error
    render json: { decode_error: "decode error" }
  end
end
