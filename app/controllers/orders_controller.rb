class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
    @order.order_items.build
    @products = Product.all
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
    @order.order_items.build if @order.order_items.empty?
    @products = Product.all
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: "Order was successfully created." }
        format.json { render  p:show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end

  end

  def api_create_order
    outcome = CreateOrder.run(params)
  
    if outcome.valid?
      render json: { message: 'Successfully created', data: outcome.result[:data] }, status: :created
    else
      render json: { error_message: outcome.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    # respond_to do |format|
    #   if @order.update(order_params)
    #     format.html { redirect_to @order, notice: "Order was successfully updated." }
    #     format.json { render :show, status: :ok, location: @order }
    #   else
    #     format.html { render :edit, status: :unprocessable_entity }
    #     format.json { render json: @order.errors, status: :unprocessable_entity }
    #   end
    # end

    @order = Order.find(params[:id])
    @products = Product.all
  
    if params[:add_item]
      # @order.assign_attributes(order_params)
      # @order.order_items.build  # add a new blank item
      render :edit
    elsif @order.update(order_params)
      redirect_to @order, notice: "Order updated successfully."
    else
      render :edit
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy!

    respond_to do |format|
      format.html { redirect_to orders_path, status: :see_other, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params.expect(:id))
    end

    # # Only allow a list of trusted parameters through.
    # def order_params
    #   params.expect(order: [ :reference_number ])
    # end

    def order_params
      params.require(:order).permit(:customer_name, order_items_attributes: [:id, :product_id, :quantity, :_destroy])
    end

    # def agency_attachment_params
    #   params.permit(:reference_number, order_items: [])
    # end
end
