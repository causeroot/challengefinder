class Admin::ChallengesController < Admin::AdminController
  # GET /admin/challenges
  # GET /admin/challenges.json
  def index
    @admin_challenges = ::Challenge.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_challenges }
    end
  end

  # GET /admin/challenges/1
  # GET /admin/challenges/1.json
  def show
    @admin_challenge = ::Challenge.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_challenge }
    end
  end

  # GET /admin/challenges/new
  # GET /admin/challenges/new.json
  def new
    @admin_challenge = ::Challenge.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_challenge }
    end
  end

  # GET /admin/challenges/1/edit
  def edit
    @admin_challenge = ::Challenge.find(params[:id])
  end

  # POST /admin/challenges
  # POST /admin/challenges.json
  def create
    @admin_challenge = ::Challenge.new(params[:admin_challenge])

    respond_to do |format|
      if @admin_challenge.save
        format.html { redirect_to @admin_challenge, notice: 'Challenge was successfully created.' }
        format.json { render json: @admin_challenge, status: :created, location: @admin_challenge }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_challenge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/challenges/1
  # PUT /admin/challenges/1.json
  def update
    @admin_challenge = ::Challenge.find(params[:id])

    respond_to do |format|
      if @admin_challenge.update_attributes(params[:admin_challenge])
        format.html { redirect_to @admin_challenge, notice: 'Challenge was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_challenge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/challenges/1
  # DELETE /admin/challenges/1.json
  def destroy
    @admin_challenge = ::Challenge.find(params[:id])
    @admin_challenge.destroy

    respond_to do |format|
      format.html { redirect_to admin_challenges_url }
      format.json { head :no_content }
    end
  end
end
