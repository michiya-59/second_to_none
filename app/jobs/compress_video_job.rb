# frozen_string_literal: true

class CompressVideoJob < ApplicationJob
  queue_as :default

  def perform video_blob
    download_blob_to_tempfile(video_blob) do |file|
      compressed_video_path = compress_video(file.path)
      replace_video_blob(video_blob, compressed_video_path)
    end
  end

  private

  def download_blob_to_tempfile(blob, &)
    blob.open(&)
  end

  def compress_video video_path
    compressed_video_path = "#{video_path}-compressed.mp4"
    system("ffmpeg", "-i", video_path, "-vcodec", "h264", "-acodec", "aac", compressed_video_path)
    compressed_video_path
  end

  def replace_video_blob blob, compressed_video_path
    blob.attach(io: File.open(compressed_video_path), filename: blob.filename, content_type: "video/mp4")
  end
end
