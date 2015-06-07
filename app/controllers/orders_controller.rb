class OrdersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @orders = Order.get_orders(@admin, current_user)
  end

  def show
    #@order = current_order
    @order = Order.find params[:id]
    @user = @order.get_user
  end

  def edit
  end

  def view
    #unless (@admin == current_user || @order.user_id = current_user.id)
    #  redirect_to root_path, :alert => "Access denied."
    #end

    @order = Order.find params[:id]
    @user = @order.get_user
  end

  def update
    @order = Order.find params[:id]
    @order.incriment_order_status

    respond_to do |format|
      if @order.update(order_params)

        #---- Process Payment ----
        #@order.make_payment

        # Tell the UserMailer to send a welcome email after save
        #OrderMailer.order_confirmation(@order).deliver_now
        #AdminOrderMailer.order_confirmation(@order, @admin).deliver_now

        #--- Clear Session ---
        #session[:order_id] = nil

        format.html { redirect_to payment_order_path(@order), notice: 'Shipping info updated succesfully.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def payment
    #@order = current_order
    @order = Order.find params[:id]
    @user = @order.get_user
  end

  def update_payment
    @order = Order.find params[:id]

    respond_to do |format|
      if @order.update(order_params)

        #---- Process Payment ----
        if @order.make_payment

        # Tell the UserMailer to send email
        OrderMailer.order_confirmation(@order).deliver_now
        AdminOrderMailer.order_confirmation(@order, @admin).deliver_now

        #--- Clear Session ---
        session[:order_id] = nil

        format.html { redirect_to root_path, notice: 'Order was submitted successfully.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :payment }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end

      else
        format.html { render :payment }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end



  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @order = Order.find params[:id]
    if (@admin == current_user || @order.get_user == current_user)
      @order.destroy
      session[:order_id] = nil
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Order was canceled successfully.' }
        format.json { head :no_content }
      end
    else
      redirect_to root_path, :alert => "Access denied."
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  #def set_order
  #  @order = Order.find(params[:id])
  #end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:subtotal, :tax, :shipping, :total, :user_id, :stripe_token, :street, :city, :state, :zip, :country)
  end


end
