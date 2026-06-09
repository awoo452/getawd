class EatLogsController < ApplicationController
  before_action :set_eat_log, only: [:destroy, :toggle_eaten]

  def create
    @eat_log = EatLog.new(eat_log_params.merge(eaten: true))
    if @eat_log.save
      @eat_log.prepared_dish&.consume_one!
      respond_with_cell_and_fridge(@eat_log.date, @eat_log.meal_slot)
    else
      redirect_to kitchen_path, alert: @eat_log.errors.full_messages.to_sentence
    end
  end

  def destroy
    date = @eat_log.date
    slot = @eat_log.meal_slot
    @eat_log.destroy
    respond_with_cell(date, slot)
  end

  def toggle_eaten
    if @eat_log.eaten?
      @eat_log.update!(eaten: false)
      @eat_log.prepared_dish&.increment!(:servings_remaining)
    else
      @eat_log.update!(eaten: true)
      @eat_log.prepared_dish&.consume_one!
    end

    respond_to do |format|
      format.turbo_stream do
        streams = [
          turbo_stream.replace(
            "eat_log_cell_#{@eat_log.date.iso8601}_#{@eat_log.meal_slot}",
            partial: "kitchen/eat_log_cell",
            locals:  eat_log_cell_locals(@eat_log.date, @eat_log.meal_slot)
          ),
          turbo_stream.replace(
            "kitchen_fridge",
            partial: "kitchen/fridge",
            locals:  { prepared_dishes: PreparedDish.active.by_date }
          )
        ]
        render turbo_stream: streams
      end
      format.html { redirect_to kitchen_path }
    end
  end

  private

  def set_eat_log
    @eat_log = EatLog.find(params[:id])
  end

  def eat_log_params
    params.require(:eat_log).permit(:date, :meal_slot, :description, :prepared_dish_id)
  end

  def respond_with_cell(date, slot)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "eat_log_cell_#{date.iso8601}_#{slot}",
          partial: "kitchen/eat_log_cell",
          locals:  eat_log_cell_locals(date, slot)
        )
      end
      format.html { redirect_to kitchen_path }
    end
  end

  def respond_with_cell_and_fridge(date, slot)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "eat_log_cell_#{date.iso8601}_#{slot}",
            partial: "kitchen/eat_log_cell",
            locals:  eat_log_cell_locals(date, slot)
          ),
          turbo_stream.replace(
            "kitchen_fridge",
            partial: "kitchen/fridge",
            locals:  { prepared_dishes: PreparedDish.active.by_date }
          )
        ]
      end
      format.html { redirect_to kitchen_path }
    end
  end

  def eat_log_cell_locals(date, slot)
    {
      date:             date,
      slot:             slot,
      eat_logs:         EatLog.where(date: date, meal_slot: slot).includes(:prepared_dish),
      prepared_dishes:  PreparedDish.active.by_date
    }
  end
end
