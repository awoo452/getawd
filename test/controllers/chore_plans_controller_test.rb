require "test_helper"

class ChorePlansControllerTest < ActionDispatch::IntegrationTest
  test "create makes a chore plan and redirects to chores" do
    assert_difference "ChorePlan.count", 1 do
      post chore_plans_url, params: {
        chore_plan: { planned_on: "2026-07-10", chore_type: "sweep_mop" }
      }
    end
    assert_redirected_to chores_url
  end

  test "create generates a task" do
    assert_difference "Task.count", 1 do
      post chore_plans_url, params: {
        chore_plan: { planned_on: "2026-07-10", chore_type: "vacuum" }
      }
    end
  end

  test "create with duplicate type and date redirects with alert" do
    ChorePlan.create!(planned_on: Date.new(2026, 7, 11), chore_type: :sweep_mop)
    assert_no_difference "ChorePlan.count" do
      post chore_plans_url, params: {
        chore_plan: { planned_on: "2026-07-11", chore_type: "sweep_mop" }
      }
    end
    assert_redirected_to chores_url
    assert flash[:alert].present?
  end

  test "destroy removes the chore plan and redirects to chores" do
    cp = ChorePlan.create!(planned_on: Date.new(2026, 8, 1), chore_type: :laundry)
    assert_difference "ChorePlan.count", -1 do
      delete chore_plan_url(cp)
    end
    assert_redirected_to chores_url
  end

  test "destroy removes the generated task" do
    cp = ChorePlan.create!(planned_on: Date.new(2026, 8, 2), chore_type: :bathroom)
    assert_difference "Task.count", -1 do
      delete chore_plan_url(cp)
    end
  end
end
