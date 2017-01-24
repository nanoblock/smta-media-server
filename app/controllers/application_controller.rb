class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token, only: [:validation]
  before_action :invalid_token_param, only: [:validation]
  before_action :invalid_token_param, :valid_token

  def validation
    token = ActiveRecord::Base.connection.select_one("SELECT * FROM tokens WHERE token = '"+token_param+"'")
    user = ActiveRecord::Base.connection.select_one("SELECT email, created_at, updated_at, email_check FROM users WHERE id = '"+token["user_id"]+"'")
    set_record_boolean(user, "email_check")

    if !token
      return render nothing: true, status: 401, json: {"status": "error", "message": "Not exsist token."}
    else
      return render nothing: true, status: :ok, json: {"user": user, "token": token}
    end
  end

  def valid_token
    @token = ActiveRecord::Base.connection.select_one("SELECT * FROM tokens WHERE token = '"+token_param+"'")

    return render nothing: true, status: 401, json: {"status": "error", "message": "Not exsist token."} if !@token
  end

  private
  def token_param
    param = nil

    if request.headers[:HTTP_ACCESS_TOKEN]
      param = request.headers[:HTTP_ACCESS_TOKEN]
    elsif params[:oauth_token]
      param = params[:oauth_token]
    elsif params[:access_token]
      param = params[:access_token] 
    end
    param
  end

  def invalid_token_param
    return render status: 400, json: {"status": "error", "message": "Not exsist param access token."} unless request.headers[:HTTP_ACCESS_TOKEN] || params[:oauth_token] || params[:access_token]
  end

  def bucket_exsist? bucket
     # {bucket.name}
    return render status: 401, json: {"status": "error", "messaage": "Not Exsist Bucket"} unless bucket.exists?
  end

  def set_record_boolean(json, column)
    @user[column.to_s] == "f" ? @user[column.to_s] = false : @user[column.to_s] = true
  end

  def s3_upload_fail message
    return render status: 400, json: {"status": "error", "message": "#{message}"}
  end

end
