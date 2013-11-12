class ChallengesController < ApplicationController
  skip_before_filter :require_login, :only => [:index, :show, :search]
	
  # GET /challenges/search
  # GET /challenges/search.xml
  def search
   	@challenges = Challenge.search do

      keywords params[:q]

      any_of do
        with(:index_deadline).greater_than(Time.now)
        with(:index_deadline, nil)
      end
        
      case params[:sort]
        when 'award_d'
          order_by(:numeric_value, :desc)
        when 'award_a'
          order_by(:numeric_value, :asc)
        when 'posted_d'
          order_by(:post_date, :desc)
        when 'posted_a'
          order_by(:post_date, :asc)
        when 'deadline_d'
          order_by(:index_deadline, :desc)
        when 'deadline_a'
          order_by(:index_deadline, :desc)
      end

      #@challenges = @activeChallenge.page params[:page]
      paginate
    end.results
    
    respond_to do |format|
      format.html { render :action => "index" }
    end
  end

  # GET /challenges
  # GET /challenges.json
  def index
    @sort = ''
    require 'date'
    require 'Chronic'
    

    # This line filters our challenges that aren't active, or the deadline
    # has passed beyond today (excluding challenges that don't have deadlines)
    @activeChallenge = Challenge.where("status = 'active'").where("index_deadline > ? OR index_deadline is null",Chronic.parse('today'))

    case params[:sort]
      when 'award_d'
        @challenges = @activeChallenge.order('numeric_value DESC').page params[:page]
      when 'award_a'
        @challenges = @activeChallenge.order('numeric_value ASC').page params[:page]
      when 'posted_d'
        @challenges = @activeChallenge.order('post_date DESC').page params[:page]
      when 'posted_a'
        @challenges = @activeChallenge.order('post_date ASC').page params[:page]
      when 'deadline_d'
        @challenges = @activeChallenge.order('index_deadline DESC').page params[:page]
      when 'deadline_a'
        @challenges = @activeChallenge.order('index_deadline ASC').page params[:page]
      else
        @challenges = @activeChallenge.page params[:page]
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /challenges/1
  # GET /challenges/1.json
  def show
    @challenge = Challenge.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /challenges/new
  # GET /challenges/new.json

  def new
    @challenge = Challenge.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /challenges/1/edit
  def edit
    @challenge = Challenge.find(params[:id])
  end

  # POST /challenges
  # POST /challenges.json
  def create
    @challenge = Challenge.new(params[:challenge])

    respond_to do |format|
      if @challenge.save
        format.html { redirect_to @challenge, notice: 'Challenge was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /challenges/1
  # PUT /challenges/1.json
  def update
    @challenge = Challenge.find(params[:id])

    respond_to do |format|
      if @challenge.update_attributes(params[:challenge])
        format.html { redirect_to @challenge, notice: 'Challenge was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /challenges/1
  # DELETE /challenges/1.json
  def destroy
    @challenge = Challenge.find(params[:id])
    @challenge.destroy

    respond_to do |format|
      format.html { redirect_to challenges_url }
    end
  end
end
