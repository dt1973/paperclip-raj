class Photo < ActiveRecord::Base
  attr_accessor :applicable_styles
  belongs_to :post, class_name: "Forem::Post"

  has_attached_file :attachment,
                    styles: lambda { |attachment| attachment.instance.applicable_styles }

  before_post_process :setup_styles
  before_save :set_attachment_is_animated

  # START DELAYED PAPERCLIP

  before_post_process :set_attachment_is_processing
  after_post_process :set_attachment_is_processing

  process_in_background :attachment
  # process_in_background :attachment, only_process: [:medium_animated], url_with_processing: false

  # END DELAYED PAPERCLIP

  validates_attachment :attachment, presence: true, content_type: {content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "video/mp4"]}

  def attachment_url(style = :medium)
    setup_styles
    style = is_animated_gif? ? "#{style.to_s}_animated".to_sym : style
    attachment.url(style)
  end

  def setup_styles
    @applicable_styles ||= {}

    if is_animated_gif?
      @applicable_styles[:medium_animated] = {
          format: "mp4",
          streaming: true,
          processors: [:ffmpeg, :qtfaststart]
      }
      @applicable_styles[:thumbnail_animated] = {
          format: "png",
          time: 0.1,
          processors: [:ffmpeg]
      }
    else
      @applicable_styles[:medium] = "480x"
      @applicable_styles[:thumbnail] = "50x50#"
    end

    @applicable_styles
  end

  private

  def is_animated_gif?
    attachment_path = attachment.queued_for_write[:original] ? attachment.queued_for_write[:original].path : attachment.path
    rmagick = Magick::ImageList.new(attachment_path)
    attachment.content_type =~ /gif/ && rmagick.scene > 1
  end

  def set_attachment_is_animated
    self.attachment_is_animated = true if is_animated_gif?
  end

  def set_attachment_is_processing
    self.attachment_is_processing = true if attachment.processing?
  end
end

