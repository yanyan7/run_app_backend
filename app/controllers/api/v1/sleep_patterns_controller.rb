module Api
  module V1
    class SleepPatternsController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_sleep_pattern, only: [:show, :update, :destroy]

      def index
        sleepPatterns = SleepPattern.order(id: :asc)
        render status: 200, json: { status: 'SUCCESS', message: 'Loaded sleep_patterns', data: sleepPatterns }
      end

      def show
        render status: 200, json: { status: 'SUCCESS', message: 'Loaded the sleep_pattern', data: @sleepPattern }
      end

      def create
        sleepPattern = SleepPattern.new(sleep_pattern_params)
        if sleepPattern.save
          render status: 201, json: { status: 'SUCCESS', data: sleepPattern }
        else
          render status: 422, json: { status: 'ERROR', data: sleepPattern.errors.full_messages }
        end
      end

      def destroy
        @sleepPattern.destroy
        render status: 200, json: { status: 'SUCCESS', message: 'Deleted the sleep_pattern', data: @sleepPattern }
      end

      def update
        if @sleepPattern.update(sleep_pattern_params)
          render status: 201, json: { status: 'SUCCESS', message: 'Updated the sleep_pattern', data: @sleepPattern }
        else
          render status: 422, json: { status: 'ERROR', message: 'Not updated', data: @sleepPattern.errors.full_messages }
        end
      end

      private

      def set_sleep_pattern
        @sleepPattern = SleepPattern.find(params[:id])
      end

      def sleep_pattern_params
        params.require(:sleep_pattern).permit(:name, :sort)
      end
    end
  end
end
