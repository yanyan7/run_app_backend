module Api
  module V1
    class DailiesController < ApplicationController
      before_action :set_daily, only: [:show, :update, :destroy]

      def index
        dailies = Daily.order(id: :asc)
        render status: 200, json: { status: 'SUCCESS', message: 'Loaded dailies', data: dailies }
      end

      def show
        render status: 200, json: { status: 'SUCCESS', message: 'Loaded the daily', data: @daily }
      end

      def create
        daily = Daily.new(daily_params)
        if daily.save
          render status: 201, json: { status: 'SUCCESS', data: daily }
        else
          render status: 422, json: { status: 'ERROR', data: daily.errors.full_messages }
        end
      end

      def destroy
        @daily.destroy
        render status: 200, json: { status: 'SUCCESS', message: 'Deleted the daily', data: @daily }
      end

      def update
        if @daily.update(daily_params)
          render status: 201, json: { status: 'SUCCESS', message: 'Updated the daily', data: @daily }
        else
          render status: 422, json: { status: 'ERROR', message: 'Not updated', data: @daily.errors.full_messages }
        end
      end

      private

      def set_daily
        @daily = Daily.find(params[:id])
      end

      def daily_params
        params.require(:daily).permit(:date, :sleep_pattern_id, :weight, :note, :deleted)
      end
    end
  end
end
