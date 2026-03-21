require "test_helper"

class VideosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @video = videos(:one)
  end

  test "should get index" do
    get videos_url
    assert_response :success
  end

  test "should get show" do
    get video_url(@video)
    assert_response :success
  end
end
