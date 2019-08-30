require "rmagick"

module ChessBoy
  class Image
		attr_accessor :text, :location

		def initialize(text, location)
			@text = text
			@location = location
		end

    def write!
			height = text.split("\n").length * 25
      width = text.split("\n")[0].length * 13
			canvas = Magick::Image.new(width, height){self.background_color = "lightslategray"}

			gc = Magick::Draw.new
			gc.pointsize(20)
			gc.font_family("Courier New")
			gc.text(10, 15, text)
			gc.draw(canvas)

			canvas.write(location)
			File.open(location)
    end
  end
end
