class ProposalsController < ApplicationController
  filter_access_to :all

  # GET /proposals
  # GET /proposals.json
  def index
    @proposals = current_user.proposals

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @proposals }
    end
  end

  # GET /proposals/1
  # GET /proposals/1.json
  def show
    id = params[:id]

    begin
        Float(id)
        if current_user
          @proposal = Proposal.find(id)
          unless current_user.proposals.map {|p| p.id.to_s} .include? id
            redirect_to root_path, :flash => { :error => 'Sem permissão, proposta não é sua.'}
            return
          end
        else
          redirect_to root_path, :flash => { :error => 'Sem permissão'}
          return
        end
        
    rescue ArgumentError, TypeError
      @proposal = Proposal.where(token: id).first
      unless @proposal 
        message = "TOKEN ACCESS inválido."
        redirect_to root_path, :flash => { :error => message}
        return
      end

    rescue Exception => e  
      redirect_to root_path, :flash => { :error => e.message}
      return 
    end

    @comment = Comment.new()
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @proposal }
    end
  end

  # GET /proposals/new
  # GET /proposals/new.json
  def new
    @proposal = Proposal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @proposal }
    end
  end

  # GET /proposals/1/edit
  def edit
    @proposal = Proposal.find(params[:id])
    unless current_user.proposals.map {|p| p.id.to_s} .include? @proposal.id.to_s
      redirect_to proposal_path, :flash => { :error => 'Sem permissão, proposta não é sua.'}
      return
    end
  end

  # POST /proposals
  # POST /proposals.json
  def create
    @proposal = Proposal.new(params[:proposal])
    @proposal.user = current_user
    respond_to do |format|
      if @proposal.save
        format.html { redirect_to @proposal, notice: 'Proposal was successfully created.' }
        format.json { render json: @proposal, status: :created, location: @proposal }
      else
        format.html { render action: "new" }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  def comment
    
    id = params[:proposal_id]

    begin
      Float(id)
      @proposal = Proposal.find(id)
    rescue ArgumentError, TypeError
      @proposal = Proposal.where(token: id).first
      unless @proposal 
        message = "TOKEN ACCESS inválido 2."
        redirect_to root_path, :flash => { :error => message}
        return
      end
    rescue Exception => e  
      redirect_to root_path, :flash => { :error => e.message}
      return 
    end

    @comment = Comment.new(params[:comment])
    @comment.proposal = @proposal

    if @comment.save
      redirect_to :back, notice: '' 
    else
      redirect_to :back, :flash => { :error => "Preencha o corpo do comentário." }
    end
  end

  # PUT /proposals/1
  # PUT /proposals/1.json
  def update
    @proposal = Proposal.find(params[:id])

    unless current_user.proposals.map {|p| p.id.to_s} .include? @proposal.id.to_s
      redirect_to proposal_path, :flash => { :error => 'Sem permissão, proposta não é sua.'}
      return
    end

    respond_to do |format|
      if @proposal.update_attributes(params[:proposal])
        format.html { redirect_to @proposal, notice: 'Proposal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proposals/1
  # DELETE /proposals/1.json
  def destroy
    @proposal = Proposal.find(params[:id])
    unless current_user.proposals.map {|p| p.id.to_s} .include? @proposal.id.to_s
      redirect_to :back, :flash => { :error => 'Sem permissão, proposta não é sua.'}
      return
    end
    @proposal.destroy

    respond_to do |format|
      format.html { redirect_to proposals_url }
      format.json { head :no_content }
    end
  end
end
