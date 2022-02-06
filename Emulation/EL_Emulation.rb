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

	def self.frame_counter
		return @frame_counter
	end

	def self.tick_frame
		@frame_counter += 1 
	end

	def self.current_song
		return @current_song
	end

	def self.current_song=(value)
		@current_song = value
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

	def self.translation
		return @translation
	end

	def self.set_translation(dx, dy)
		@translation = SDC.xy(dx, dy)
	end

	def self.reset_translation
		@translation = SDC.xy
	end

	def self.parse_color(color)
		b = color % 0x100
		rest = ((color - b) / 0x100).to_i
		g = rest % 0x100
		rest = ((rest - g) / 0x100).to_i
		r = rest % 0x100
		rest = ((rest - r) / 0x100).to_i
		alpha = rest % 0x100

		return SDC::Graphics::Color.new(r, g, b, alpha: alpha)
	end
	
	def self.init
		@main_path = Dir.getwd
		@frame_counter = 0
		@running_song = nil

		self.reset_translation
	end

end

Emulation.init