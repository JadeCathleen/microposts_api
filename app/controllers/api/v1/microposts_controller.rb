class Api::V1::MicropostsController < Api::V1::BaseController
  before_action :set_micropost, only: %i[ show update destroy ]

  # GET /microposts
  def index
    scope = Micropost.includes(:user)

    # --- Filtering ---
    if params[:q].present?
      scope = scope.where("microposts.title ILIKE ? OR microposts.body ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")
    end

    if params[:user_id].present?
      scope = scope.where(user_id: params[:user_id])
    end

    # --- Sorting ---
    scope = case params[:sort]
    when "created_at_desc"  then scope.order(created_at: :desc)
    when "created_at_asc"   then scope.order(created_at: :asc)
    when "title_asc"       then scope.order("LOWER(title) ASC")
    when "title_desc"      then scope.order("LOWER(title) DESC")
    else               scope.order(created_at: :desc)
    end

    # --- Pagination ---
    per_page = params[:per_page].to_i
    per_page = 5 if per_page <= 0
    per_page = 20 if per_page > 20

    @pagy, @microposts = pagy(scope, limit: per_page)
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
