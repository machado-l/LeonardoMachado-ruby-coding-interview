class UsersController < ApplicationController

  def index
    users = User
              .by_company(search_params[:company_id])
              .by_username(search_params[:username])
    render json: users.all
  end

  private

  def search_params
    params.permit(:company_id, :username)
  end

end
