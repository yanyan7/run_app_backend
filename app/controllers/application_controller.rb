class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include DeviseHackFakeSession

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action do
    I18n.locale = :ja
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name]) # nameを変更可能にする
  end

  def set_search_key
    if params[:user_id] && params[:year] && params[:month]
      # user_idを検証する(usersテーブルに存在するか)
      User.find(params[:user_id])

      # パラメータをセット
      @user_id = params[:user_id]
      @date_from = Date.new(
        params[:year].to_i,
        params[:month].to_i,
        1
      )
      @date_to = Date.new(
        params[:year].to_i,
        params[:month].to_i,
        -1
      )
    else
      render status: 422, json: { status: 'ERROR', message: 'ユーザーID、期間を指定して下さい' }
    end
  end
end
