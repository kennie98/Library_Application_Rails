class ApiController < ActionController::Base
# devise defines this, while knock is using `method_missing`
  # undef_method :current_user
#attr_reader :current_user
#
  skip_before_action :verify_authenticity_token

  before_action :set_default_format
  before_action :authenticate_token!

  helper_method :current_api_user


  private

  def set_default_format
    request.format = :json
  end

  def authenticate_token!
    payload = JsonWebToken.decode(auth_token)
    @current_user = User.find(payload["sub"])
  rescue JWT::ExpiredSignature
    render json: {errors: ["Auth token has expired"]}, status: :unauthorized
  rescue JWT::DecodeError
    render json: {errors: ["Invalid auth token"]}, status: :unauthorized

  end

  def current_api_user
    payload = JsonWebToken.decode(auth_token)
    @current_api_user = User.find(payload["sub"])
  end

  def auth_token
    @auth_token ||= request.headers.fetch("Authorization", "").split(" ").last
  end

end
