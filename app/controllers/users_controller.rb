class UsersController < ApplicationController
  before_action :normalize_filters, only: %i[index]
  before_action :repository

  def repository
    @repository = UsersRepository.new(data_source: User) if @repository.nil?
  end

  # GET /users
  def index
    @page, @limit, @order, @filter, @fields = list_data

    @users = @repository.index(@page, @limit, @order, @filter, @fields)
    @meta = meta(@page, @limit, @users[:total])

    render json: default_return(@users[:data], @meta)
  end

  # GET /users/1
  def show
    @user = @repository.show(params[:id])
    render json: @user
  end

  def rescan
    @user = @repository.show(params[:id])

    begin
      RescanService.index(@user)
    rescue StandardError => e
      render json: { 'message': e }, status: 422
      return
    end

    render json: @user
  end

  # POST /users
  def create
    @user = @repository.create(user_params)

    if @user.persisted?
      begin
        RescanService.index(@user)
      rescue StandardError => e
        render json: { 'message': e }, status: 422
        return
      end
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    @user = @repository.update(params[:id], user_params)

    if @user.errors.empty?
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user = @repository.destroy(params[:id])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  # def set_user
  #   @user = User.find(params[:id])
  # end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :githubUser)
  end
end
