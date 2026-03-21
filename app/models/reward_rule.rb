class RewardRule < ApplicationRecord
  belongs_to :reward

  def satisfied?
    return true if rule_type.blank?

    true
  end
end
