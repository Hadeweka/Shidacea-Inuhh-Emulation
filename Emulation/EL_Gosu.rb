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
	KbR = SDC::EventKey::R
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
		return Emulation.frame_counter * 16.66666666666667
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
				@font.load_from_file("arlrdbd.ttf")
			end
		end

		def draw(text, x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)
			text = SDC::Text.new(text.to_s, @font, scale_x * 16)
			text.color = Emulation.parse_color(color)
			SDC.window.draw_translated(text, z, SDC::Coordinates.new(x, y) + Emulation.translation)
		end

		def text_width(text, scale_x = 1)
			return 0
		end

	end

	class Image

		def initialize(source, options = {})
			if source.is_a? SDC::Sprite then
				@sprite = source
			else
				Emulation.temp_path(Emulation.main_path + "/" + SDC::Script.path + "/Inuhh-Shinvasion") do
					@sprite = SDC::Sprite.new
					texture = SDC::Data.load_texture((SDC::Data::SYMBOL_PREFIX + source).to_sym, filename: source)
					@sprite.link_texture(texture)
				end
			end
		end

		def self.load_tiles(window, source, tile_width, tile_height, tiled, options = {})
			return self.load_tiles(source, tile_width, tile_height, options)
		end

		def self.load_tiles(source, tile_width, tile_height, options = {})
			return_array = []
			Emulation.temp_path(Emulation.main_path + "/" + SDC::Script.path + "/Inuhh-Shinvasion") do
				# TODO: Only load the image once as soon as Shidacea provides the option to
				full_texture = SDC::Data.load_texture((SDC::Data::SYMBOL_PREFIX + source).to_sym, filename: source)
				full_texture_size = full_texture.size

				nx = full_texture_size.x.to_i / tile_width
				ny = full_texture_size.y.to_i / tile_height

				0.upto(nx - 1) do |ix|
					0.upto(ny - 1) do |iy|
						sprite = SDC::Sprite.new

						symbol_index = (SDC::Data::SYMBOL_PREFIX + source + "___#{ix}_#{iy}").to_sym

						if !SDC::Data.textures[symbol_index] then

							texture = SDC::Texture.new
							texture.load_from_file(source, SDC::IntRect.new(ix * tile_width, iy * tile_height, tile_width, tile_height))
							SDC::Data.add_texture(texture, index: symbol_index)

						end

						sprite.link_texture(SDC::Data.textures[symbol_index])

						return_array[iy * nx + ix] = Image.new(sprite)
					end
				end
			end

			return return_array
		end

		def draw(x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)
			@sprite.scale = SDC::Coordinates.new(scale_x, scale_y)
			@sprite.color = Emulation.parse_color(color)

			SDC.window.draw_translated(@sprite, z, SDC::Coordinates.new(x, y) + Emulation.translation)
		end

		def draw_rot(x, y, z, angle, center_x=0.5, center_y=0.5, scale_x=1, scale_y=1, color=0xff_ffffff, mode=:default)
			@sprite.scale = SDC::Coordinates.new(scale_x, scale_y)
			@sprite.color = Emulation.parse_color(color)
			@sprite.origin = SDC::Coordinates.new(center_x * @sprite.texture_rect.width, center_y * @sprite.texture_rect.height)
			@sprite.rotation = angle

			SDC.window.draw_translated(@sprite, z, SDC::Coordinates.new(x, y) + Emulation.translation)
		end

	end

	class Sample

		def initialize(filename)
			Emulation.temp_path(Emulation.main_path + "/" + SDC::Script.path + "/Inuhh-Shinvasion") do
				sound_buffer = SDC::Data.load_sound_buffer((SDC::Data::SYMBOL_PREFIX + filename).to_sym, filename: filename)
				@sound = SDC::Sound.new
				@sound.link_sound_buffer(sound_buffer)
			end
		end

		def play(volume, speed, looping = false)
			@sound.volume = volume * 100.0
			@sound.pitch = speed
			@sound.play
		end

		def stop
			@sound.stop
		end

	end

	class Song

		def self.current_song
			return Emulation.current_song
		end

		def initialize(filename)
			Emulation.temp_path(Emulation.main_path + "/" + SDC::Script.path + "/Inuhh-Shinvasion") do
				@song = SDC::Music.new
				@song.open_from_file(filename)
			end
		end

		def play(looping)
			@song.play
			Emulation.current_song = self
		end

		def stop
			@song.stop
		end

	end

	class TextInput

		attr_accessor :text, :caret_pos

		def initialize
			@caret_pos = 0
			@text = ""
		end

	end
	
	class Window

		attr_accessor :width, :height, :caption, :text_input

		def initialize(width, height, options = {})
			@width = width
			@height = height
			@text_input = nil
			Emulation.gosu_game = self
		end

		def show
			Emulation.in_path_dir do
				main_routine(SceneDummy, SDC::BaseGame, @caption, @width, @height)
			end
		end

		def close
			SDC.next_scene = nil
		end

	end

end