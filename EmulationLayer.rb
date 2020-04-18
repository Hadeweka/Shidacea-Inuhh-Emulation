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

	# TODO: Fix conflict between symbols and constants
	KbEscape = SDC::EventKey::Escape
	KbReturn = SDC::EventKey::Enter 
	KbW = SDC::EventKey::W
	KbA = SDC::EventKey::A
	KbS = SDC::EventKey::S
	KbD = SDC::EventKey::D
	KbLeft = SDC::EventKey::Left
	KbRight = SDC::EventKey::Right
	KbUp = SDC::EventKey::Up
	KbDown = SDC::EventKey::Down

	def self.default_font_name
		return ""
	end

	def scale(sx, sy, &block)
		block.call
	end

	def milliseconds
		return 0
	end

	def button_down?(arg)
		return SDC::key_pressed?(arg)
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

		def close
			SDC.next_scene = nil
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

	def handle_event(event)
		if event.has_type?(:KeyPressed) then
			Emulation.gosu_game.button_down(event.key_code)

		elsif event.has_type?(:Closed)
			SDC.next_scene = nil

		end
	end

end