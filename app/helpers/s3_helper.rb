module S3Helper
    def game_image_url(game)
        key = "games/#{game.id}/#{game.game_image}"
        s3_url(key)
    end

    def s3_image_url(folder, *parts)
        key = ([folder] + parts).join("/")
        s3_url(key)
    end

    def s3_url(key)
        return nil if key.blank?
        s3_media_path(key: key)
  end
end
