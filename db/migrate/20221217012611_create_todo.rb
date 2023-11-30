class CreateTodo < ActiveRecord::Migration[7.0]
  def change
    create_table :todos do |t|
      t.string :todo, null: false, limit: 191
      t.references :user, foreign_key: true, null: false
      t.references :todo_statuses, foreign_key: true, null: false
      t.timestamps
    end
  end
end
