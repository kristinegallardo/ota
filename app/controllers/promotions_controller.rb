class PromotionsController < ApplicationController
  before_action :set_promotion, only: %i[ show edit update destroy ]

  # @promotion_types = %w[fixed bundle bulk percentage].freeze

  # GET /promotions or /promotions.json
  def index
    @promotions = Promotion.all
  end

  # GET /promotions/1 or /promotions/1.json
  def show
  end

  # GET /promotions/new
  def new
    @promotion_types = Promotion::PROMOTION_TYPES
    @promotion = Promotion.new
    @promotion.products.build
    @products = Product.all
  end

  # GET /promotions/1/edit
  def edit
  end

  # POST /promotions or /promotions.json
  def create
    @promotion = Promotion.new(promotion_params)

    respond_to do |format|
      if @promotion.save
        format.html { redirect_to @promotion, notice: "Promotion was successfully created." }
        format.json { render :show, status: :created, location: @promotion }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @promotion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /promotions/1 or /promotions/1.json
  def update
    # respond_to do |format|
    #   if @promotion.update(promotion_params)
    #     format.html { redirect_to @promotion, notice: "Promotion was successfully updated." }
    #     format.json { render :show, status: :ok, location: @promotion }
    #   else
    #     format.html { render :edit, status: :unprocessable_entity }
    #     format.json { render json: @promotion.errors, status: :unprocessable_entity }
    #   end
    # end

    @promotion = Promotion.find(params[:id])
    @products = Product.all
  
    if params[:add_item]
      # @order.assign_attributes(order_params)
      # @order.order_items.build  # add a new blank item
      render :edit
    elsif @promotion.update(promotion_params)
      redirect_to @promotion, notice: "Promotion updated successfully."
    else
      render :edit
    end
  end

  # DELETE /promotions/1 or /promotions/1.json
  def destroy
    @promotion.destroy!

    respond_to do |format|
      format.html { redirect_to promotions_path, status: :see_other, notice: "Promotion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_promotion
      @promotion = Promotion.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def promotion_params
      params.require(:promotion)
            .permit(:name, :code, :description, 
                    :promotion_type, :discounted_price, :quantity,
                    products_attributes: [:id, :name, :_destroy])
    end
end
