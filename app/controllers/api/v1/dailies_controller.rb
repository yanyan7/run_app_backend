module Api
  module V1
    class DailiesController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_daily, only: [:show, :update, :destroy]
      before_action :set_search_key, only: [:index]

      def index
        dailies = Daily.joins(
          "LEFT OUTER JOIN sleep_patterns ON dailies.sleep_pattern_id = sleep_patterns.id"
        ).where(
          user_id: @user_id
        ).where(
          "date BETWEEN ? AND ?", @date_from, @date_to
        ).select("dailies.*, sleep_patterns.name AS sleep_pattern_name")

        if dailies.empty?
          render status: 404, json: { status: 'ERROR', message: 'Not Found' }
        else
          render status: 200, json: { status: 'SUCCESS', message: 'Loaded dailies', data: dailies }
        end
      end

      def show
        results = @daily.results
        daily = @daily.attributes.symbolize_keys # ActiveModel(Resultクラス)からハッシュに変換
        daily[:results] = results

        render status: 200, json: { status: 'SUCCESS', message: 'Loaded the daily', data: daily }
      end

      def create
        error_massages = []
        daily = create_daily(error_massages)

        if error_massages.empty?
          render status: 201, json: { status: 'SUCCESS', message: 'データを登録しました', data: daily }
        else
          render status: 422, json: { status: 'ERROR', data: error_massages }
        end
      end

      def destroy
        @daily.destroy
        render status: 200, json: { status: 'SUCCESS', message: 'Deleted the daily', data: @daily }
      end

      def update
        error_massages = []
        daily = update_daily(error_massages)

        if error_massages.empty?
          render status: 201, json: { status: 'SUCCESS', message: 'データを更新しました', data: daily }
        else
          render status: 422, json: { status: 'ERROR', message: 'Not updated', data: error_massages }
        end
      end

      private

      def set_daily
        @daily = Daily.find(params[:id])
      end

      def daily_params
        params.require(:daily).permit(:date, :user_id, :sleep_pattern_id, :weight, :note, :deleted).merge(results: params[:results])
      end

      def create_daily(error_massages)
        daily = nil
        results = []

        ApplicationRecord.transaction do
          # dailyを作成
          _daily = {
            date: daily_params[:date],
            user_id: daily_params[:user_id],
            sleep_pattern_id: daily_params[:sleep_pattern_id],
            weight: daily_params[:weight],
            note: daily_params[:note],
            deleted: 0
          }
          daily = Daily.create(_daily)
          if !daily.persisted?
            error_massages.push(daily.errors.full_messages)
            raise ActiveRecord::Rollback # ロールバック
          end
          
          # resultを作成
          create_result(daily[:id], results, error_massages)
        end

        daily = daily.attributes.symbolize_keys # ActiveModel(Resultクラス)からハッシュに変換
        daily[:results] = results
        return daily
      end

      def update_daily(error_massages)
        daily = nil
        results = []

        ApplicationRecord.transaction do
          # dailyを更新
          _daily = {
            sleep_pattern_id: daily_params[:sleep_pattern_id],
            weight: daily_params[:weight],
            note: daily_params[:note]
          }
          if !@daily.update(_daily)
            error_massages.push(@daily.errors.full_messages)
            raise ActiveRecord::Rollback # ロールバック
          end

          # resultを削除
          Result.where(daily_id: @daily[:id]).destroy_all
          
          # resultを作成
          create_result(@daily[:id], results, error_massages)
        end

        daily = @daily.attributes.symbolize_keys # ActiveModel(Resultクラス)からハッシュに変換
        daily[:results] = results
        return daily
      end

      def create_result(daily_id, results, error_massages)
        params[:results].each_with_index do |_result, index|
          result = Result.create(
            {
              daily_id: daily_id,
              user_id: _result[:user_id],
              date: _result[:date],
              temperature: _result[:temperature],
              timing_id: _result[:timing_id],
              content: _result[:content],
              distance: _result[:distance],
              time_h: _result[:time_h],
              time_m: _result[:time_m],
              time_s: _result[:time_s],
              pace_m: _result[:pace_m],
              pace_s: _result[:pace_s],
              place: _result[:place],
              shoes: _result[:shoes],
              note: _result[:note],
              deleted: 0
            }
          )
          if !result.persisted?
            error_massages.concat(
              result.errors.full_messages.map do |message|
                "練習#{index + 1}: #{message}"
              end
            )
            raise ActiveRecord::Rollback # ロールバック
          end
          results.push(result)
        end
      end
    end
  end
end
