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
    if params[:"user_id"] && params[:"year_month"]
      @user_id = params[:"user_id"]
      @date_from = "#{params[:"year_month"]}-01"
      @date_to = "#{params[:"year_month"]}-31"
    else
      render status: 422, json: { status: 'ERROR', message: 'ユーザーID、期間を指定して下さい' }
    end
  end
end
