module ApplicationHelper
  def safe_asset_path(asset_name)
    asset_path(asset_name)
  rescue Sprockets::Rails::Helper::AssetNotFound, Sprockets::Rails::Helper::AssetNotPrecompiled
    nil
  end
end
