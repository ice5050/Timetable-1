class TablesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @tables = @user.tables.order("created_at DESC")
  end

  def new
    @user = User.find(params[:user_id])
    @table = @user.tables.new
  end

  def create
    @user = User.find(params[:user_id])
    @table = @user.tables.create(params_table)
    redirect_to user_tables_path
  end

  def edit
    @user = User.find(params[:user_id])
    @table = @user.tables.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @table = @user.tables.find(params[:id])
    @table.update(params_table)
    redirect_to user_tables_path
  end

  def destroy
    @user = User.find(params[:user_id])
    @table = @user.tables.find(params[:id])
    @table.destroy
    redirect_to user_tables_path
  end

  private
    def params_table
        params.require(:table).permit(:name)
    end
end
