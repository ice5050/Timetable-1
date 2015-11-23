class RegularexamsController < ApplicationController
  http_basic_authenticate_with name: "pondpaun7z", password: "0PP-7z-;"
  def index
    @regulars = Regularexam.order("ordered ASC")
    @days = Day.order("id ASC")
    @times = Timer.all
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

  def edit_day
    @day = Day.find(params[:id])
  end

  def update_day
    @day = Day.find(params[:id])
    @day.update(params_day)
    redirect_to regularexams_path
  end

  private
    def params_regular
        params.require(:regular).permit(:dayexam, :timeexam, :dateexam, :yearexam, :semesterexam, :ordered)
    end

    def params_day
        params.require(:day).permit(:day)
    end
end

