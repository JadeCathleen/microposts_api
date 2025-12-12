class Api::V1::MicropostsController < Api::V1::BaseController
  include ActionController::Flash

  before_action :set_micropost, only: %i[ show update destroy ]

  # GET /microposts
  def index
    @microposts = Micropost.all
  end

  # GET /microposts/1
  def show
  end

  # POST /microposts
  def create
    @micropost = Micropost.new(micropost_params)

    if @micropost.save
      flash[:notice] = "Micropost created successfully!"
      render json: { micropost: @micropost, flash: flash.to_hash }, status: :created
    else
      flash[:alert] = "Failed to create micropost (#{@micropost.errors.full_messages.join(', ')})"
      render json: { flash: flash.to_hash }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /microposts/1
  def update
    if @micropost.update(micropost_params)
      flash[:notice] = "Micropost updated successfully!"
      render json: { micropost: @micropost, flash: flash.to_hash }
    else
      flash[:alert] = "Failed to update micropost (#{@micropost.errors.full_messages.join(', ')})"
      render json: { flash: flash.to_hash }, status: :unprocessable_entity
    end
  end

  # DELETE /microposts/1
  def destroy
    @micropost.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_micropost
      @micropost = Micropost.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def micropost_params
      params.require(:micropost).permit(:id, :title, :body)
    end
end
