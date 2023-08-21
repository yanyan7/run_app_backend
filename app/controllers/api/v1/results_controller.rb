require 'date'

module Api
  module V1
    class ResultsController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_result, only: [:show, :update, :destroy]
      before_action :set_search_key, only: [:index]

      def index
        dailies = make_index_data

        if dailies.empty?
          render status: 404, json: { status: 'ERROR', message: 'Not Found' }
        else
          render status: 200, json: { status: 'SUCCESS', message: 'Loaded results', data: dailies }
        end
      end

      def show
        render status: 200, json: { status: 'SUCCESS', message: 'Loaded the result', data: @result }
      end

      def create
        result = Result.new(result_params)
        if result.save
          render status: 201, json: { status: 'SUCCESS', data: result }
        else
          render status: 422, json: { status: 'ERROR', data: result.errors.full_messages }
        end
      end

      def destroy
        @result.destroy
        render status: 200, json: { status: 'SUCCESS', message: 'Deleted the result', data: @result }
      end

      def update
        if @result.update(result_params)
          render status: 201, json: { status: 'SUCCESS', message: 'Updated the result', data: @result }
        else
          render status: 422, json: { status: 'ERROR', message: 'Not updated', data: @result.errors.full_messages }
        end
      end

      private

      def set_result
        @result = Result.find(params[:id])
      end

      def result_params
        params.require(:result).permit(
          :daily_id, :user_id, :date, :temperature, :timing_id,
          :content, :distance, :time_h, :time_m, :time_s, :pace_m,
          :pace_s, :place, :shoes, :note, :deleted
        )
      end

      def make_index_data
        # まずはdailyを取得する
        dailies = Daily.joins(
          "LEFT OUTER JOIN sleep_patterns ON dailies.sleep_pattern_id = sleep_patterns.id"
        ).where(
          user_id: @user_id
        ).where(
          "date BETWEEN ? AND ?", @date_from, @date_to
        ).select(
          "dailies.id AS daily_id,
          CAST(DATE_FORMAT(dailies.date,'%Y') AS SIGNED) AS year,
          CAST(DATE_FORMAT(dailies.date,'%c') AS SIGNED) AS month,
          CAST(DATE_FORMAT(dailies.date,'%e') AS SIGNED) AS day,
          dailies.sleep_pattern_id,
          sleep_patterns.name AS sleep_pattern_name,
          dailies.weight,
          dailies.note AS daily_note"
        ).to_a

        # データが無い日を空データで埋める
        days_count = Date.new(params[:year].to_i, params[:month].to_i, -1).day.to_i # その月の日数を取得
        days_count.times do |num|
          data = dailies.find { |daily| daily[:day] == num + 1 }

          if !data
            # 対象日のデータが無い場合、空データを追加
            dailies.push(
              {
                daily_id: nil,
                year: params[:year].to_i,
                month: params[:month].to_i,
                day: num + 1,
                sleep_pattern_id: nil,
                sleep_pattern_name: nil,
                weight: nil,
                daily_note: nil
              }
            )
          end
        end

        # 曜日を追加
        tmp_dailies = []
        dailies.map do |daily|
          if daily.class.name != "Hash"
            # ActiveModel(Dailyクラス)からハッシュに変換
            daily = daily.attributes.symbolize_keys
          end
          date = Date.new(daily[:year], daily[:month], daily[:day])
          daily[:weekday] = %w(日 月 火 水 木 金 土)[date.wday]

          tmp_dailies.push(daily)
        end
        dailies = tmp_dailies

        # resultを取得
        results = Result.joins(
          "LEFT OUTER JOIN timings ON results.timing_id = timings.id"
        ).where(
          user_id: @user_id
        ).where(
          "results.date BETWEEN ? AND ?", @date_from, @date_to
        ).select(
          "results.id AS result_id,
          results.daily_id,
          results.user_id,
          results.date,
          results.temperature,
          results.timing_id,
          timings.name AS timing_name,
          results.content,
          results.distance,
          concat(results.time_h, ':', results.time_m, ':', results.time_s) AS time,
          concat(results.pace_m, ':', results.pace_s) AS pace,
          results.place,
          results.shoes,
          results.note AS result_note,
          results.deleted,
          results.created_at,
          results.updated_at"
        ).to_a

        tmp_results = []
        results.map do |result|
          # ActiveModel(Resultクラス)からハッシュに変換
          result = result.attributes.symbolize_keys
          tmp_results.push(result)
        end
        results = tmp_results

        # dailiesとresultsを結合
        dailies.map do |daily|
          daily[:results] = []
          data = results.select { |result| result[:daily_id] == daily[:daily_id] }
          daily[:results] = data
        end

        # 日付順にソート
        dailies.sort_by! { |daily| daily[:day] }
      end
    end
  end
end
