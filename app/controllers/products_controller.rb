class ProductsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_action :set_product, only: [:show, :edit, :update, :destroy]


  # GET /products
  # GET /products.json
  def index
    @products = Product.all
    @order_item = current_order.order_items.new
  end

  # GET /products/1
  # GET /products/1.json
  def show
    user = current_user
    @product_price = ProductPrice.where(product_id: @product.id,  user_id: user.id)
  end

  # GET /products/new
  def new
    #--Authorize--
    unless @admin == current_user
      redirect_to root_path, :alert => "Access denied."
    end
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    #--Authorize--
    unless @admin == current_user
      redirect_to root_path, :alert => "Access denied."
    end
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update

    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy

    #--Authorize--
    if @admin == current_user
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  else
    redirect_to root_path, :alert => "Access denied."
  end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :description, :group_id, :image, :default_price)
    end
end
