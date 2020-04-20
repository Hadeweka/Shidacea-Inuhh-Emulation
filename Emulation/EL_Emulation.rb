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

	def self.translation
		return @translation
	end

	def self.set_translation(dx, dy)
		@translation = SDC::Coordinates.new(dx, dy)
	end

	def self.reset_translation
		@translation = SDC::Coordinates.new
	end
	
	def self.init
		@main_path = Dir.getwd

		self.reset_translation
	end

end

Emulation.init