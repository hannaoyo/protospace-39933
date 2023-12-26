class PrototypesController < ApplicationController
  #before_action :move_to_index, except: [:index, :show, :new, :create]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy] #except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :show]

  def index
    @prototypes = Prototype.includes(:user).order("created_at DESC")
  end

  def show
    @prototype = Prototype.find(params[:id])
    @user = @prototype.user
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
    else
      render :edit
    end
  end

  def create
    existing_prototype = current_user.prototypes.find_by(prototype_params.except(:image))

    if existing_prototype
      # すでに同じプロトタイプが存在する場合の処理
      redirect_to root_path
    else
      @prototype = current_user.prototypes.new(prototype_params)
      
      if @prototype.save
      # 重複するプロトタイプを削除
      #@prototypes = Prototype.order(created_at: :desc)
      redirect_to root_path
      else
      render :new, status: :unprocessable_entity
      end
    end
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def move_to_index
    redirect_to root_path unless user_signed_in?
  end

  def correct_user
    @prototype = Prototype.find(params[:id])
    # ログインしていない場合はログインページにリダイレクト
    unless user_signed_in?
      redirect_to new_user_session_path
      return
    end
    # ログインしているが投稿者でない場合はトップページにリダイレクト
    unless @prototype.user == current_user
      redirect_to root_path
    end
  end
  
  #def move_to_index
   # redirect_to root_path unless user_signed_in?
  #end
end
