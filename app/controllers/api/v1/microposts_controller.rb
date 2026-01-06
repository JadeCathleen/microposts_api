class Api::V1::MicropostsController < Api::V1::BaseController
  before_action :set_micropost, only: %i[ show update destroy ]

  # GET /microposts
  def index
    @microposts = Micropost.includes(:user).all
  end

  # GET /microposts/1
  def show
  end

  # POST /microposts
  def create
    @micropost = current_user.microposts.build(micropost_params)

    if @micropost.save
      render :show,
      status: :created,
      locals: {
        flash: { notice: "Micropost created successfully!" }
      }
    else
      render json: {
        flash: {
          alert: "Failed to create micropost (#{@micropost.errors.full_messages.join(', ')})"
        }
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /microposts/1
  def update
    if @micropost.update(micropost_params)
      render :show,
      status: :ok,
      locals: {
        flash: { notice: "Micropost updated successfully!" }
      }
    else
      render json: {
      flash: {
        alert: "Failed to update micropost (#{@micropost.errors.full_messages.join(', ')})"
      }
    }, status: :unprocessable_entity
    end
  end

  # DELETE /microposts/1
  def destroy
    @micropost.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_micropost
      @micropost = current_user.microposts.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def micropost_params
      params.require(:micropost).permit(:title, :body)
    end
end
