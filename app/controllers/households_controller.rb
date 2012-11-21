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
    
    @h = LazyHighCharts::HighChart.new('graph') do |f|
      f.options[:chart][:defaultSeriesType] = "line"
      # f.options[:chart][:inverted] = "True"
      f.series( name: 'First', 
                data: Household.first.get_readings_for(params[:from], params[:to]),
                pointStart: DateTime.strptime(params[:from], "%Y-%m-%d").to_time.to_i*1000,
                pointInterval: 24 * 3600 * 1000  
      )
      # f.series(:name=>'Second', :data=>Household.last.energy_records.get_readings_for(params[:from], params[:to]))
      f.xAxis(type: :datetime, maxZoom: 24*3600*1000)
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
end
