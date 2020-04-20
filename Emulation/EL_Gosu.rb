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
	KbBackspace = SDC::EventKey::Backspace
	KbTab = SDC::EventKey::Tab
	KbSpace = SDC::EventKey::Space
	KbLeftControl = SDC::EventKey::LControl
	KbRightControl = SDC::EventKey::RControl
	KbLeftShift = SDC::EventKey::LShift
	KbRightShift = SDC::EventKey::RShift
	Kb1 = SDC::EventKey::Num1
	Kb2 = SDC::EventKey::Num2
	Kb3 = SDC::EventKey::Num3
	Kb4 = SDC::EventKey::Num4
	Kb5 = SDC::EventKey::Num5
	KbP = SDC::EventKey::P
	KbF1 = SDC::EventKey::F1
	KbF2 = SDC::EventKey::F2
	KbF3 = SDC::EventKey::F3
	KbF4 = SDC::EventKey::F4
	KbF5 = SDC::EventKey::F5
	KbF6 = SDC::EventKey::F6
	KbF7 = SDC::EventKey::F7
	KbF8 = SDC::EventKey::F8
	KbF9 = SDC::EventKey::F9
	KbF10 = SDC::EventKey::F10
	KbF11 = SDC::EventKey::F11
	KbF12 = SDC::EventKey::F12


	MsWheelDown = SDC::EventMouse::VerticalWheel
	MsWheelUp = SDC::EventMouse::VerticalWheel

	def self.default_font_name
		return ""
	end

	def scale(sx, sy, &block)
		block.call
	end

	def translate(dx, dy, &block)
		# TODO: Use viewports for that, maybe, at least for scale and rotate?
		Emulation.set_translation(dx, dy)
		block.call
		Emulation.reset_translation
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
			SDC.window.draw_translated(text, SDC::Coordinates.new(x, y) + Emulation.translation)
		end

		def text_width(text, scale_x = 1)
			return 0
		end

	end

	class Image

		def initialize(source, options = {})
			Emulation.temp_path(Emulation.main_path + "/" + SDC::Script.path + "/Inuhh-Shinvasion") do
				@sprite = SDC::Sprite.new
				texture = SDC::Data.load_texture((SDC::Data::SYMBOL_PREFIX + source).to_sym, filename: source)
				@sprite.link_texture(texture)
			end
		end

		def self.load_tiles(window, source, tile_width, tile_height, tiled, options = {})
			return Array.new(4, Image.new(source))
		end

		def self.load_tiles(source, tile_width, tile_height, options = {})
			return Array.new(50, Image.new(source))
		end

		def draw(x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)
			SDC.window.draw_translated(@sprite, SDC::Coordinates.new(x, y) + Emulation.translation)
		end

		def draw_rot(x, y, z, angle, center_x=0.5, center_y=0.5, scale_x=1, scale_y=1, color=0xff_ffffff, mode=:default)
			SDC.window.draw_translated(@sprite, SDC::Coordinates.new(x, y) + Emulation.translation)
		end

	end

	class Sample

		def initialize(filename)

		end

		def play(volume, speed, looping = false)
			
		end

	end

	class Song

		def self.current_song
			return nil
		end

		def initialize(filename)

		end

		def play(volume, speed, looping = false)
			
		end

	end

	class TextInput

		attr_accessor :text, :caret_pos

		def initialize
			@caret_pos = 0
		end

	end
	
	class Window

		attr_accessor :width, :height, :caption, :text_input

		def initialize(width, height, options = {})
			@width = width
			@height = height
			Emulation.gosu_game = self
		end

		def show
			Emulation.in_path_dir do
				puts "Loading main routine..."
				main_routine(SceneDummy, SDC::BaseGame, @caption, @width, @height)
			end
		end

		def close
			SDC.next_scene = nil
		end

	end

end