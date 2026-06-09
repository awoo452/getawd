class PreparedDishesController < ApplicationController
  def destroy
    dish = PreparedDish.find(params[:id])
    dish.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("prepared_dish_#{dish.id}")
      end
      format.html { redirect_to kitchen_path }
    end
  end
end
