class UsersController < ApplicationController
  before_action :move_to_index, except: [:show, :new, :create]
  def show
    @user = User.find(params[:id])
    @prototypes = @user.prototypes
  end
end
