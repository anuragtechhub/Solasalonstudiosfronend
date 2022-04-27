# frozen_string_literal: true

class Sola10kController < PublicWebsiteController
  require 'RMagick'
  # require 'FileUtils'

  skip_before_action :verify_authenticity_token

  def index
    last_approved_sola10k_image = Sola10kImage.select(:updated_at).order(updated_at: :desc).first
    cache_key = "/sola10k/approved-images?last_approved_at=#{last_approved_sola10k_image ? last_approved_sola10k_image.updated_at : DateTime.now}"

    @gallery_images = Rails.cache.fetch(cache_key) do
      Sola10kImage.where(approved: true).to_a.to_json
    end
    render layout: params[:layout] if params[:layout]
  end

  def show
    @sola10k_image = Sola10kImage.find_by(public_id: params[:id])
  end

  def image_preview
    # update and save Sola10kImage with statement, variant, etc
    @sola10k_image = Sola10kImage.find_by(public_id: params[:id]) || Sola10kImage.new
    @sola10k_image.name = params[:name] if params[:name].present?
    @sola10k_image.instagram_handle = params[:instagram_handle] if params[:instagram_handle].present?
    @sola10k_image.statement = params[:statement] if params[:statement].present?
    @sola10k_image.color = params[:color] if params[:color].present?

    generated_image = generate_image(@sola10k_image.image, @sola10k_image.statement, @sola10k_image.color)

    if @sola10k_image.changed?
      generated_image_file = Tempfile.new("sola10k#{@sola10k_image.id}")
      generated_image.write(generated_image_file.path)

      @sola10k_image.generated_image = generated_image_file # File.open("mysola#{@sola10k_image.id}.jpg")
      @sola10k_image.save
    end

    send_data generated_image.to_blob, filename: 'sola10k.jpg', type: :jpg
  end

  def image_upload
    @sola10k_image = Sola10kImage.create
    @sola10k_image.image = params[:file]
    @sola10k_image.save

    render json: @sola10k_image
  end

  private

    def calculate_cursive_pointsize(image, draw, text)
      pointsize = 100 # 222
      width = 920

      while width >= 920
        pointsize -= 20
        draw.pointsize = pointsize
        width = draw.get_type_metrics(image, text)[:width]
      end

      pointsize
    end

    def generate_image(image, statement, color)
      # p "generate image"
      m_image = Magick::Image.read(image.url(:original)).first.resize_to_fill!(1080, 1080)

      # blue overlay
      blue_overlay = Magick::Draw.new
      blue_overlay.fill = 'rgba(73, 156, 211, 0.1)'
      blue_overlay.rectangle(0, 0, 1080, 1080)
      blue_overlay.draw(m_image)

      # gradient color overlay
      m_gradient = case color
                   when 'black'
                     Magick::Image.read(Rails.root.join('app/assets/images/sola10kgradientblack.png')).first
                   when 'pink'
                     Magick::Image.read(Rails.root.join('app/assets/images/sola10kgradientpink.png')).first
                   else
                     Magick::Image.read(Rails.root.join('app/assets/images/sola10kgradientblue.png')).first
                   end
      m_combined = m_image.composite(m_gradient, 0, 0, Magick::OverCompositeOp)

      # my logo
      my_logo = if statement.present?
                  Magick::Image.read(Rails.root.join('app/assets/images/sola10k_mysola_comma.png')).first
                else
                  Magick::Image.read(Rails.root.join('app/assets/images/sola10k_mysola_nocomma.png')).first
                end
      m_combined = m_combined.composite(my_logo, 0, 0, Magick::OverCompositeOp)

      if statement.present?
        cursive_text = Magick::Draw.new
        cursive_text.font = "#{Rails.root}/lib/fonts/ChaletParisNineteenSixty.ttf"
        cursive_text.gravity = Magick::CenterGravity
        cursive_text.fill = '#ffffff'
        cursive_text_pointsize = calculate_cursive_pointsize(m_combined, cursive_text, statement)
        cursive_text.pointsize = cursive_text_pointsize
        Rails.logger.debug { "cursive_text_pointsize=#{cursive_text_pointsize}" }
        m_combined.annotate(cursive_text, 1080, 1080, 0, 120, "my #{statement.strip}")

        cursive_text_metrics = cursive_text.get_type_metrics(m_combined, statement)
        ascent = cursive_text_metrics[:ascent]
        descent = cursive_text_metrics[:descent]
        height = cursive_text_metrics[:height]
        calculated_height = height + descent # + 160
        y_value = -(ascent - (statement =~ /[A-Z]/ ? 50 : 150)) / 2
      end

      # sola10k logo
      sola10k_logo = Magick::Image.read(Rails.root.join('app/assets/images/hashsola10klogo.png')).first
      m_combined = m_combined.composite(sola10k_logo, 520 - (188 / 2), 900, Magick::OverCompositeOp)

      # 10,000... copy
      # sola10k_copy = Magick::Image.read(Rails.root.join('app/assets/images/sola10kcopy.png')).first
      # m_combined = m_combined.composite(sola10k_copy, 520 - (335 / 2), 948, Magick::OverCompositeOp)
      copy_text = Magick::Draw.new
      copy_text.font = "#{Rails.root}/lib/fonts/ChaletParisNineteenSixty.ttf"
      copy_text.font_weight = 600
      copy_text.gravity = Magick::CenterGravity
      copy_text.fill = '#ffffff'
      copy_text.pointsize = 30
      m_combined.annotate(copy_text, 1080, 1080, 0, 470, '10,000 individual stories. One powerful community.')

      # white stroke
      sola10k_frame = Magick::Image.read(Rails.root.join('app/assets/images/sola10kframe.png')).first
      m_combined.composite(sola10k_frame, 0, 0, Magick::OverCompositeOp)
      # white_stroke = Magick::Draw.new
      # white_stroke.fill_opacity(0)
      # white_stroke.stroke('#ffffff')
      # white_stroke.stroke_width(4)
      # white_stroke.rectangle(40, 40, 1035, 1035)
      # white_stroke.draw(m_combined)
    end
end
