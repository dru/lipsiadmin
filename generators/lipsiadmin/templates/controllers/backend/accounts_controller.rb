class Backend::AccountsController < BackendController
  def index
    respond_to do |format|
      format.html { render_javascript(formatted_backend_accounts_path(:js)) }
      format.js 
      format.json do 
        accounts = Account.find(:all)
        return_data = Hash.new 
        return_data[:accounts] = accounts.collect { |u| { :id => u.id,
                                                          :email => u.email,
                                                          :active => u.active?, 
                                                          :created_at => u.created_at } }
        render :json => return_data
      end
    end
  end

  def new
    @account = Account.new
    roles
    project_modules LipsiaSoft::AccessControl.roles.first
    render :partial => "new"
  end
  
  def create
    @account = Account.new(params[:account])
    roles
    project_modules @account.role
    if @account.save
      redirect_to_parent(:action => "edit", :id => @account)
    else
      render_to_parent(@account, :partial => "new")
    end
  end
  
  def edit
    @account = Account.find(params[:id])
    roles
    project_modules @account.role
    render :partial => "edit"
  end
  
  def update
    @account = Account.find(params[:id])
    roles
    project_modules @account.role
    if @account.update_attributes(params[:account])
      redirect_to_parent(:action => "edit", :id => @account)
    else
      render_to_parent(@account, :partial => "edit")
    end 
  end
  
  def destroy
    if Account.find(params[:id]).destroy
      render :json => { :success => true } 
    else
      render :json => { :success => false, :msg => "You cannot delete this record." }
    end  
  end

  def activate
    self.current_account = params[:activation_code].blank? ? :false : Account.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_account.active?
      current_account.activate
      flash[:notice] = "Activation Completed!"
    end
    redirect_to :controller => :sessions, :action => :new
  end
  
  def refresh_project_modules
    project_modules params[:role]
    @account = Account.find_by_id(params[:id]) || Account.new
    render :update do |page|
      page.replace_html(:project_modules, :partial => "project_modules")
      page.visual_effect(:blind_down, :project_modules)
    end
  end
  
private
  def roles
    @roles = LipsiaSoft::AccessControl.human_roles
  end
  
  def project_modules(role)
    @project_modules = LipsiaSoft::AccessControl.project_modules(role)
  end
end