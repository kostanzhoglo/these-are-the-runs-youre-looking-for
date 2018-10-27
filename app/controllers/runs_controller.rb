class RunsController < ApplicationController
  before_action :authentication_required
  before_action :set_month, only: [:create, :edit, :update, :destroy]

  def create
    @run = @month.runs.build(run_params)
    @run[:user_id] = current_user.id
    @run[:pace_per_mile] = @run.format_pace_per_mile
    if @run.save
      # redirect_to month_path(@month)
      render json: @run, status: 201
    else
      @month = Month.find(params[:month_id])
      @runs = @month.runs
      render 'months/show'
    end
  end

  def index
    @user = current_user
    if params[:month_id]
      @runs = @user.months.find(params[:month_id]).runs
    else
      @runs = @user.runs.all
    end
  end

  def show
    @month = current_user.months.find_by(id: params[:month_id])
    @run = current_user.runs.find_by(id: params[:id])
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @run }  # because of AMS.
    end
  end

  def next
    @run = current_user.runs.find_by(id: params[:id])
    @next_run = @run.next
    render json: @next_run
  end

  def edit
    @run = Run.find_by(id: params[:id])
  end

  def update
    @run = @month.runs.find(params[:id])
    if @run.update(run_params)
      @run.update_attributes({:pace_per_mile => @run.format_pace_per_mile})
      redirect_to month_path(@month)
    else
      render :edit
    end
  end

  def destroy
    @run = @month.runs.find(params[:id])
    @run.destroy
    redirect_to month_path(@run.month)
  end

  def fastest_pace
    @runs = Run.fastest_pace
  end

  def longest_runs
    @runs = Run.longest_runs
  end

  private
    def set_month
      @month = Month.find(params[:month_id])
    end

    def run_params
      params.require(:run).permit(:date, :name, :distance, :duration, :pace_per_mile, :notes, :number_intervals, :interval_length, :rest_between_interval, :month_id)
    end

end
