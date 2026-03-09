class Users::SessionsController < Devise::SessionsController
  def create
    params[resource_name] ||= {}
    params[resource_name][:remember_me] = "1"
    super
  end
end
