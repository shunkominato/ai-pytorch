class CreateTodoStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :todo_statuses do |t|
      t.string :status, null: false, limit: 191
      t.timestamps
    end
  end
end
