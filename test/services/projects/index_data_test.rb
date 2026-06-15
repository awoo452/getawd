require "test_helper"

class Projects::IndexDataTest < ActiveSupport::TestCase
  PAGINATOR = ->(scope, per_page:) { [scope.to_a, 1, 1] }

  test "returns without error" do
    assert_nothing_raised { Projects::IndexData.call(paginator: PAGINATOR) }
  end

  test "returns projects with page metadata" do
    result = Projects::IndexData.call(paginator: PAGINATOR)
    assert_respond_to result, :projects
    assert_equal 1, result.projects_page
    assert_equal 1, result.projects_total_pages
  end
end
