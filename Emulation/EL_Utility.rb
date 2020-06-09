def require(arg)

end

def require_all(arg)

end

$LOAD_PATH = ""

class File

	def self.basename(arg_1, arg_2)
		return arg_1.gsub(arg_2, "")
	end

	def self.readlines(filename, &block)
		return []
	end

end

class Dir

	def self.glob(arg, &block)
		arg = arg[2..-1] if arg[0] == "."
		args = arg.split("*")

		actual_path = Dir.getwd + "/#{args[0]}"

		if Dir.exists?(actual_path) then
			Dir.foreach(actual_path) do |file|
                next if file == "dummy"
				next if file[0] == "."
				block.call(file)
			end
		end
	end

end

class Entity

end

class Enemy < Entity

end

Marshal = SDC::Marshal