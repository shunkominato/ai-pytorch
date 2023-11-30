class Api::V1::TodosController < ApplicationController
  Alba.inflector = :active_support

  def index
    todo = Todo.select(:id, :todo, :user_id, :todo_statuses_id)
    # binding.pry

    render json: {
      todoList: IndexResource.new(todo).serializable_hash
    }, status: :ok
  end

  def create
    @todo = Todo.new(todo_params)
    begin
      @todo.save!
    rescue => e
      Slack::ErrorNotificator.Notifice(1, "todo/create", e, "todo: #{@todo.to_json}")
      return render json: { message: "Todoの作成に失敗しました" }, status: :internal_server_error
    end

    render json: {
      todo: CreateResource.new(@todo).serializable_hash
    }, status: :created
  end

  private
  def todo_params
    params.permit(:todo, :user_id, :todo_statuses_id)
  end

end
