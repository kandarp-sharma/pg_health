Rails.application.routes.draw do
  mount PgHealth::Engine => "/pg_health"
end
