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

class Complex

    def self.sqrt(value)
        if value.is_a? Complex then
            new_abs = Math::sqrt(value.abs)
            new_arg = 0.5 * value.arg
            return self.polar(new_abs, new_arg)
        elsif value >= 0 then
            return Math::sqrt(value)
        else
            return Complex.new(0.0, -Math::sqrt(-value))
        end
    end

    def self.cbrt(value)
        if value.is_a? Complex then
            new_abs = Math::cbrt(value.abs)
            new_arg = (1/3) * value.arg
            return self.polar(new_abs, new_arg)
        else
            return Math::sqrt(value)
        end
    end

end
