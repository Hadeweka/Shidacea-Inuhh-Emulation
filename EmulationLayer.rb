def require(arg)

	puts "Overriding required file or library: #{arg}"

end

def require_all(arg)

	puts "Overriding required files: #{arg}"

end

$LOAD_PATH = ""

class Entity

end

class Enemy < Entity

end

class Dir

	def self.glob(arg)

	end

end

module Gosu

	def self.default_font_name
		return ""
	end

	class Color

	end

	class Font

		def initialize(height, options = {})

		end

		def initialize(window, font_name, height)

		end

	end

	class Image

		def initialize(source, options = {})

		end

		def self.load_tiles(source, tile_width, tile_height, options = {})

		end

	end

	class Sample

		def initialize(filename)

		end

	end

	class Song

		def initialize(filename)

		end

	end

	class TextInput

		def text=(value)

		end

	end
	
	class Window

		def initialize(width, height, options = {})
			
		end

		def caption=(value)

		end

		def text_input=(value)

		end

		def show
			puts "Initial dummy methods successful"
		end

	end

end