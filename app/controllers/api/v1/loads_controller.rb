module Api
  module V1
    class LoadsController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_load, only: [:show, :update, :destroy]

      def index
        loads = Load.order(id: :asc)
        if loads.empty?
          render status: 404, json: { status: 'ERROR', message: 'Not Found' }
        else
          render status: 200, json: { status: 'SUCCESS', message: 'Loaded loads', data: loads }
        end
      end

      def show
        render status: 200, json: { status: 'SUCCESS', message: 'Loaded the load', data: @load }
      end

      def create
        load = Load.new(load_params)
        if load.save
          render status: 201, json: { status: 'SUCCESS', data: load }
        else
          render status: 422, json: { status: 'ERROR', data: load.errors.full_messages }
        end
      end

      def destroy
        @load.destroy
        render status: 200, json: { status: 'SUCCESS', message: 'Deleted the load', data: @load }
      end

      def update
        if @load.update(load_params)
          render status: 201, json: { status: 'SUCCESS', message: 'Updated the load', data: @load }
        else
          render status: 422, json: { status: 'ERROR', message: 'Not updated', data: @load.errors.full_messages }
        end
      end

      private

      def set_load
        @load = Load.find(params[:id])
      end

      def load_params
        params.require(:load).permit(:name, :sort)
      end
    end
  end
end
