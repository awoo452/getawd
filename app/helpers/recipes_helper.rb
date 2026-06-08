module RecipesHelper
  def ingredient_quantity_label(ri)
    fi = ri.food_item
    if fi.serving_size.present?
      amt = ri.quantity * fi.servings_per_unit
      amt_str = amt % 1 == 0 ? amt.to_i.to_s : amt.round(2).to_s.sub(/\.?0+$/, "")
      "#{amt_str} #{fi.serving_size}"
    else
      "#{ri.quantity} #{fi.unit}"
    end
  end
end
