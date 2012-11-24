class HouseholdsController < ApplicationController
  # GET /households
  # GET /households.json
  def index
    @households = Household.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @households }
    end
  end

  # GET /households/1
  # GET /households/1.json
  def show
    @household = Household.find(params[:id])
    if params[:search]
      @start_time = DateTime.strptime(params[:search][:date_from], "%Y-%m-%d")
      @end_time = DateTime.strptime(params[:search][:date_to], "%Y-%m-%d")
    else
      @start_time = EnergyRecord.first.period_end.to_date
      @end_time = @start_time + 7.days
    end

    calculate_ticks

    @h = LazyHighCharts::HighChart.new('graph', style: '') do |f|
      f.options[:chart][:defaultSeriesType] = current_user.chart_type
      f.series( name: 'First', 
                data: Household.first.get_readings_for(@start_time, @end_time, @unit)
      )
      # f.series( name: 'Second', 
      #           data: Household.last.get_readings_for(@start_time, @end_time, @unit)
      # )
      f.xAxis(type: :datetime,
              labels: {
                rotation: -60,
                align: 'right',
                style: {
                    fontSize: '13px',
                    fontFamily: 'Verdana, sans-serif'
                }
              },
              tickInterval: @interval,
              gridLineColor: '#bfbfc0',
              gridLineDashStyle: 'ShortDash',
              gridLineWidth: '1')
      f.options[:title][:text] = "lala"
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @household }
    end
  end

  def change
    
  end

  # GET /households/new
  # GET /households/new.json
  def new
    @household = Household.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @household }
    end
  end

  # GET /households/1/edit
  def edit
    @household = Household.find(params[:id])
  end

  # POST /households
  # POST /households.json
  def create
    @household = Household.new(params[:household])

    respond_to do |format|
      if @household.save
        format.html { redirect_to @household, notice: 'Household was successfully created.' }
        format.json { render json: @household, status: :created, location: @household }
      else
        format.html { render action: "new" }
        format.json { render json: @household.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /households/1
  # PUT /households/1.json
  def update
    @household = Household.find(params[:id])

    respond_to do |format|
      if @household.update_attributes(params[:household])
        format.html { redirect_to @household, notice: 'Household was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @household.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /households/1
  # DELETE /households/1.json
  def destroy
    @household = Household.find(params[:id])
    @household.destroy

    respond_to do |format|
      format.html { redirect_to households_url }
      format.json { head :no_content }
    end
  end

  private

  def calculate_ticks
    diff = @end_time - @start_time
    if diff < 2
      @unit = "hour"
      @interval = 3600*1000
    elsif diff < 32
      @unit = "day"
      @interval = 24*3600*1000
    else
      @unit = "week"
      @interval = 7*24*3600*1000
    end
  end
end
