class KindsController < ApplicationController
before_filter :check_for_admin
  # GET /kinds
  # GET /kinds.json
  def index
    @kinds = Kind.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kinds }
    end
  end

  # GET /kinds/1
  # GET /kinds/1.json
  def show
    @kind = Kind.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kind }
    end
  end

  # GET /kinds/new
  # GET /kinds/new.json
  def new
    @kind = Kind.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kind }
    end
  end

  # GET /kinds/1/edit
  def edit
    @kind = Kind.find(params[:id])
  end

  # POST /kinds
  # POST /kinds.json
  def create
    @kind = Kind.new(params[:kind])

    respond_to do |format|
      if @kind.save
        format.html { redirect_to @kind, notice: 'Kind was successfully created.' }
        format.json { render json: @kind, status: :created, location: @kind }
      else
        format.html { render action: "new" }
        format.json { render json: @kind.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kinds/1
  # PUT /kinds/1.json
  def update
    @kind = Kind.find(params[:id])

    respond_to do |format|
      if @kind.update_attributes(params[:kind])
        format.html { redirect_to @kind, notice: 'Kind was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @kind.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kinds/1
  # DELETE /kinds/1.json
  def destroy
    @kind = Kind.find(params[:id])
    @kind.destroy

    respond_to do |format|
      format.html { redirect_to kinds_url }
      format.json { head :ok }
    end
  end
end
