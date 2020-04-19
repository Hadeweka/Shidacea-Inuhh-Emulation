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

	def self.main_path=(value)
		@main_path = value
	end

	def self.main_path
		return @main_path
	end

	def self.in_path_dir(&block)
		Dir.chdir(SDC::Script.path)
		Dir.chdir("Inuhh-Shinvasion")
		block.call
		Dir.chdir("../../..")
	end

	def self.temp_path(path, &block)
		old_path = SDC::Script.path.dup
		SDC::Script.path = path
		block.call
		SDC::Script.path = old_path
	end

end

Emulation.main_path = Dir.getwd

module Marshal

	INDICATOR_INT = 'i'.bytes[0]
	INDICATOR_ARRAY = '['.bytes[0]
	INDICATOR_STRING = '"'.bytes[0]

	def self.load(file)
		version = file.sysread(2)
		puts"\nVERSION: #{version.bytes[0]}.#{version.bytes[1]}"

		return self.interpret(file)
	end

	def self.interpret(file)
		indicator = file.sysread(1).bytes[0]
		puts "INDICATOR: #{indicator.chr} (#{indicator})"

		if indicator == INDICATOR_INT then
			type = file.sysread(1).bytes[0]
			puts "TYPE: #{type}"

			if type == 0 then
				return 0
			else
				puts "Not implemented yet: Integer type #{type}"
				return nil
			end

		elsif indicator == INDICATOR_ARRAY then
			length_marker = file.sysread(1).bytes[0]
			length = 0
			puts "LENGTH_MARKER: #{length_marker}"

			if length_marker >= 5 then
				# Length of array is lower than 123
				length = length_marker - 5
				puts "LENGTH: #{length}"

			else
				# Length of array is 123 or higher
				length_bytes = file.sysread(length_marker).bytes
				puts "LENGTH BYTES: #{length_bytes}"

				# Reconstruct the length from the bytes
				power_of_eight = 1
				length_bytes.each do |lb|
					length += lb * power_of_eight
					power_of_eight *= 8
				end

				puts "LENGTH: #{length}"

			end

			final_array = Array.new(length)

			0.upto(length - 1) do |i|
				final_array[i] = self.interpret(file)
			end

		else
			puts "Not implemented yet: Indicator #{indicator}"
			return nil
		end
	end

end

class Entity

end

class Enemy < Entity

end

class File

	def self.basename(arg_1, arg_2)
		return arg_1.delete(arg_2)
	end

end

class Dir

	def self.glob(arg, &block)
		arg = arg[2..-1] if arg[0] == "."
		args = arg.split("*")

		actual_path = Dir.getwd + "/#{args[0]}"

		if Dir.exists?(actual_path) then
			Dir.foreach(actual_path) do |file|
				next if file[0] == "."
				block.call(file)
			end
		end
	end

end

module Gosu

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

	def draw_line(x1, y1, c1, x2, y2, c2, z = 0, mode = :default)

	end

	def milliseconds
		return rand(1000)
	end

	def button_down?(key)
		return SDC.window.has_focus? && SDC::EventKey.is_pressed?(key)
	end

	class Color

	end

	class Font

		def initialize(height, options = {})
			@font = SDC::Font.new
		end

		def initialize(window, font_name, height)
			@font = SDC::Font.new
			Emulation.temp_path(Emulation.main_path + "/" + SDC::Script.path) do
				@font.load_from_file("arial.ttf")
			end
		end

		def draw(text, x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)
			text = SDC::Text.new(text, @font, scale_x * 18)
			SDC.window.draw_translated(text, SDC::Coordinates.new(x, y))
		end

		def text_width(text, scale_x = 1)
			return 0
		end

	end

	class Image

		def initialize(source, options = {})
			path = "Inuhh-Shinvasion/#{source}"
			@sprite = SDC::Sprite.new
			texture = SDC::Data.load_texture((SDC::Data::SYMBOL_PREFIX + path).to_sym, filename: path)
			@sprite.link_texture(texture)
		end

		def self.load_tiles(source, tile_width, tile_height, options = {})

		end

		def draw(x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)
			SDC.window.draw_translated(@sprite, SDC::Coordinates.new(x, y))
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

		attr_accessor :text, :caret_pos

		def initialize
			@caret_pos = 0
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
			Emulation.in_path_dir do
				puts "Initial dummy methods successful"
				main_routine(SceneDummy, SDC::Game, @caption, @width, @height)
			end
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
			puts "Terminating..."
			SDC.next_scene = nil

		end
	end

end
