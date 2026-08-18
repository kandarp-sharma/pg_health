module PgHealth
  class Engine < ::Rails::Engine
    isolate_namespace PgHealth

    # Enables middleware configuration: PgHealth::Engine.use(...)
    def self.use(*args, &block)
      middleware.use(*args, &block)
    end
  end
end
