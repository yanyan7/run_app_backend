module Api
  module V1
    class TimingsController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_timing, only: [:show, :update, :destroy]

      def index
        timings = Timing.order(id: :asc)
        render status: 200, json: { status: 'SUCCESS', message: 'Loaded timings', data: timings }
      end

      def show
        render status: 200, json: { status: 'SUCCESS', message: 'Loaded the timing', data: @timing }
      end

      def create
        timing = Timing.new(timing_params)
        if timing.save
          render status: 201, json: { status: 'SUCCESS', data: timing }
        else
          render status: 422, json: { status: 'ERROR', data: timing.errors.full_messages }
        end
      end

      def destroy
        @timing.destroy
        render status: 200, json: { status: 'SUCCESS', message: 'Deleted the timing', data: @timing }
      end

      def update
        if @timing.update(timing_params)
          render status: 201, json: { status: 'SUCCESS', message: 'Updated the timing', data: @timing }
        else
          render status: 422, json: { status: 'ERROR', message: 'Not updated', data: @timing.errors.full_messages }
        end
      end

      private

      def set_timing
        @timing = Timing.find(params[:id])
      end

      def timing_params
        params.require(:timing).permit(:name, :sort)
      end
    end
  end
end
