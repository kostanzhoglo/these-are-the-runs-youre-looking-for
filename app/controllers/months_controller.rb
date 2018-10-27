class MonthsController < ApplicationController
  before_action :authentication_required

  def index
    @months = current_user.months.uniq
    @month = Month.new
  end

  def show
    @month = current_user.months.find_by(id: params[:id])
    @run = Run.new
    @runs = @month.runs
    respond_to do |format|
      format.html
      format.json { render json: @month }  # because of AMS.
    end
  end

  def create
    @month = @current_user.months.build(month_params)
    @month[:user_id] = @current_user.id
    if @month.save
      redirect_to month_url(@month)
    else
      @months = current_user.months.uniq
      render :index
    end
  end

  private

    def month_params
      params.require(:month).permit(:name, :year, :goal, :user_id)
    end

end
