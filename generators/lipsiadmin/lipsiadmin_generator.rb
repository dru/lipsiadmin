class LipsiadminGenerator < Rails::Generator::Base
  def manifest
    # Initial routes
    routes = <<-ROUTES
  map.namespace(:backend, :path_prefix => :admin) do |backend|
    backend.resources :accounts
    backend.resources :sessions
  end

  map.backend                 '/admin', :controller => 'backend/base', :action => 'index'
  map.welcome                 '/admin/welcome', :controller => 'backend/base', :action => 'welcome'
  map.activation              '/admin/accounts/activate/:activation_code', :controller => 'backend/accounts', :action=>'activate'
  map.refresh_project_modules '/admin/accounts/refresh_project_modules', :controller => 'backend/accounts', :action=>'refresh_project_modules'
  map.connect                 '/javascripts/:action.:format', :controller => 'javascripts'
  ROUTES
    
    record do |m|
      m.append("config/routes.rb", routes, "ActionController::Routing::Routes.draw do |map|")
      m.append("public/robots.txt", "User-agent: *\nDisallow: /admin")
      m.create_all("controllers", "app/controllers/")
      m.create_all("helpers", "app/helpers/")
      m.create_all("images", "public/images")
      m.create_all("javascripts", "public/javascripts")
      m.create_all("stylesheets", "public/stylesheets")
      m.create_all("layouts", "app/views/layouts/")
      m.create_all("models", "app/models")
      m.create_all("views", "app/views/")
      m.create_all("config", "config")
      m.migration_template("migrations/create_accounts.rb", "db/migrate", :migration_file_name => "create_accounts")
      m.readme "../REMEMBER"      
    end
  end

  protected
    def banner
      "Usage: #{$0} lipsiadmin"
    end
end