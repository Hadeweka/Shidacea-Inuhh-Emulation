def require(arg)

	puts "Overriding required file or library: #{arg}"

end

def require_all(arg)

	puts "Overriding required files: #{arg}"

end

$LOAD_PATH = ""

module Emulation

	def self.gosu_game=(value)
		@gosu_game = value
	end

	def self.gosu_game
		return @gosu_game
	end

end

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

	def scale(sx, sy, &block)
		block.call
	end

	def milliseconds
		return 0
	end

	class Color

	end

	class Font

		def initialize(height, options = {})

		end

		def initialize(window, font_name, height)

		end

		def draw(text, x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)

		end

	end

	class Image

		def initialize(source, options = {})

		end

		def self.load_tiles(source, tile_width, tile_height, options = {})

		end

		def draw(x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)

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

		attr_accessor :width, :height, :caption

		def initialize(width, height, options = {})
			@width = width
			@height = height
			Emulation.gosu_game = self
		end

		def text_input=(value)

		end

		def show
			puts "Initial dummy methods successful"
			main_routine(SceneDummy, SDC::Game, @caption, @width, @height)
		end

	end

end

class SceneDummy < SDC::Scene

	def update
		Emulation.gosu_game.update
	end

	def draw
		Emulation.gosu_game.draw
	end

end