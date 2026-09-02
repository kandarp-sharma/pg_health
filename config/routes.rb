PgHealth::Engine.routes.draw do
	root to: "dashboard#overview_dashboard"

	# get 'overview_dashboard', to: "dashboard#overview_dashboard", as: "overview_dashboard"
	get 'table_health', to: "dashboard#table_health", as: "table_health"
	get 'storage_bloat', to: "dashboard#storage_bloat", as: "storage_bloat"
	get 'index_tuning', to: "dashboard#index_tuning", as: "index_tuning"
	get 'locks_activity', to: "dashboard#locks_activity", as: "locks_activity"
end
