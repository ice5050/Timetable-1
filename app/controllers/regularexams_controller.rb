class RegularexamsController < ApplicationController
  def index
    @regulars = Regularexam.order("ordered ASC")
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

  private
    def params_regular
        params.require(:regular).permit(:dayexam, :timeexam, :dateexam, :yearexam, :semesterexam, :ordered)
    end
end

