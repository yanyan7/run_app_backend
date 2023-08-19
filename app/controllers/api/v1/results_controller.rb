module Api
  module V1
    class ResultsController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_result, only: [:show, :update, :destroy]

      def index
        # results = Result.order(id: :asc)
        results = Daily.joins( # 外部結合
          "LEFT OUTER JOIN sleep_patterns ON dailies.sleep_pattern_id = sleep_patterns.id
          LEFT OUTER JOIN results ON dailies.id = results.daily_id
          LEFT OUTER JOIN timings ON results.timing_id = timings.id"
        ).select(
          "dailies.id AS daily_id,
          dailies.date,
          dailies.sleep_pattern_id,
          sleep_patterns.name AS sleep_pattern_name,
          dailies.weight,
          dailies.note AS daily_note,
          results.id AS result_id,
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
          results.updated_at
          "
        )
        render status: 200, json: { status: 'SUCCESS', message: 'Loaded results', data: results }
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
          :date, :daily_id, :date, :temperature, :timing_id,
          :content, :distance, :time_h, :time_m, :time_s, :pace_m,
          :pace_s, :place, :shoes, :note, :deleted
        )
      end
    end
  end
end
class ResultsController < ApplicationController
end
