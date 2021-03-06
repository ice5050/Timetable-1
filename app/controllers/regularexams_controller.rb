class RegularexamsController < ApplicationController
  before_action :require_login
  
  def index
    @regulars = Regularexam.order("yearexam DESC, semesterexam DESC, ordered ASC")
  end

  def new
    @regular = Regularexam.new
  end

  def create
    @regular = Regularexam.new(params_regular)
    @regular.save
    redirect_to regularexams_path
  end

  def edit
    @regular = Regularexam.find(params[:id])
  end

  def update
    @regular = Regularexam.find(params[:id])
    @regular.update(params_regular)
    redirect_to regularexams_path
  end

  def destroy
    @regular = Regularexam.find(params[:id])
    @regular.destroy
    redirect_to regularexams_path
  end

  private
    def params_regular
        params.require(:regular).permit(:dayexam, :timeexam, :dateexam, :yearexam, :semesterexam, :ordered)
    end

    def require_login
      unless current_user.username == 'pondpaun7z'
        redirect_to homepages_path
      end
    end

end

