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
    @table2 = @user.tables.find(@table.id)
    
    redirect_to controller: 'classtables', action: 'index', table_id: @table.id

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

  def reset
      @user = User.find(params[:user_id])
      @table = @user.tables.find(params[:id])
      @classes = @table.classtables.delete_all

      redirect_to controller: 'classtables', action: 'index', table_id: @table.id
  end

  private
    def params_table
        params.require(:table).permit(:name, :year, :semester)
    end
end
