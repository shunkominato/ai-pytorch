class IndexResource
  include Alba::Resource
  root_key!
  attributes :id, :todo, :user_id, :todo_statuses_id
  transform_keys :lower_camel, root: true
end
