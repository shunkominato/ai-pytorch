class Api::V1::TodoStatusesController < ApplicationController
  def index
    @todo_statuses = TodoStatus.all
    render json: {
      todoStatus: @todo_statuses
    }
  end
end
