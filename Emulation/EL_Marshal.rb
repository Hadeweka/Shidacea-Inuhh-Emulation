module Marshal

	INDICATOR_NIL = "0".bytes[0]
	INDICATOR_TRUE = "T".bytes[0]
	INDICATOR_FALSE = "F".bytes[0]
	INDICATOR_INT = "i".bytes[0]
	INDICATOR_ARRAY = "[".bytes[0]
	INDICATOR_STRING = "\"".bytes[0]
	INDICATOR_SYMBOL = ":".bytes[0]
	INDICATOR_SYMBOL_LINK = ";".bytes[0]
	INDICATOR_INSTANCE_VAR = "I".bytes[0]
	INDICATOR_HASH = "{".bytes[0]
	INDICATOR_USER_MARSHAL = "U".bytes[0]

	def self.read_byte(file)
		return self.read_bytes(file, 1)[0]
	end

	def self.read_bytes(file, n)
		read_array = file.read(n)
		return read_array.bytes
	end

	def self.read_integer(file)
		length_marker = self.read_byte(file)
		value = 0

		if length_marker == 0 then
			value = 0

		elsif length_marker.between?(5, 127)
			# Value is a small positive int
			value = length_marker - 5

		elsif length_marker.between?(128, 251)
			# Value is a small negative int
			value = length_marker - 256 + 5

		else
			# Value is made out of more than one byte
			negative_value = length_marker > 128
			actual_byte_length = (negative_value ? 256 - length_marker : length_marker)

			length_bytes = self.read_bytes(file, actual_byte_length)

			# Reconstruct the value from the bytes
			power_of_256 = 1
			0.upto(actual_byte_length - 1) do |i|
				if negative_value && i == actual_byte_length - 1 then
					value -= (256 - length_bytes[i]) * power_of_256
				else
					value += length_bytes[i] * power_of_256
					power_of_256 *= 256
				end
			end
			
		end

		return value
	end

	def self.init
		@symbols = []
	end

	def self.add_symbol(sym)
		@symbols.push(sym)
	end

	def self.ref_symbol(index)
		return @symbols[index]
	end

	def self.load(file)
		self.init
		version = self.read_bytes(file, 2)

		obj = self.interpret(file)
		return obj
	end

	def self.dump(value, file)
		self.init

		self.convert(value, file)
	end

	def self.convert(value, file)
		
	end

	def self.interpret(file)
		indicator = self.read_byte(file)

		if indicator == INDICATOR_NIL then
			return nil

		elsif indicator == INDICATOR_TRUE then
			return true

		elsif indicator == INDICATOR_FALSE then
			return false

		elsif indicator == INDICATOR_INT then
			value = self.read_integer(file)

			return value

		elsif indicator == INDICATOR_INSTANCE_VAR then
			obj = self.interpret(file)

			length = self.read_integer(file)

			has_encoding = true if obj.is_a?(String)

			0.upto(length - 1) do |i|
				name = self.interpret(file)
				value = self.interpret(file)

				if has_encoding then
					# TODO: Maybe an encoding check
				else
					obj.instance_variable_set("@#{name}", value)
				end
			end

			return obj

		elsif indicator == INDICATOR_STRING then
			length = self.read_integer(file)

			# NOTE: May not work properly with weird characters
			result = self.read_bytes(file, length).pack("U*")

			return result

		elsif indicator == INDICATOR_SYMBOL then
			length = self.read_integer(file)

			result = self.read_bytes(file, length).pack("U*").to_sym

			self.add_symbol(result)

			return result

		elsif indicator == INDICATOR_SYMBOL_LINK then
			index = self.read_byte(file)

			return self.ref_symbol(index)

		elsif indicator == INDICATOR_ARRAY then
			length = self.read_integer(file)

			final_array = Array.new(length)

			0.upto(length - 1) do |i|
				final_array[i] = self.interpret(file)
			end

			return final_array

		elsif indicator == INDICATOR_HASH then
			length = self.read_integer(file)

			final_hash = {}

			0.upto(length - 1) do |i|
				index = self.interpret(file)
				value = self.interpret(file)

				final_hash[index] = value
			end

			return final_hash

		elsif indicator == INDICATOR_USER_MARSHAL then
			# User-defined marshal_dump and marshal_load
			symbol = self.interpret(file)


			# Allocate new object of given class and initialize it using marshal_load
			marshalled_object = self.interpret(file)
			klass = Kernel.const_get(symbol)
			new_object = klass.allocate
			new_object.marshal_load(marshalled_object)

			return new_object

		else
			puts "Not implemented yet: Indicator #{indicator.chr} (#{indicator})"
			other_bytes = file.read(100)
			puts "Next 100 bytes: " + other_bytes.bytes.inspect
			puts "Next 100 chars: " + other_bytes.chars.inspect
			puts "Terminating execution..."
			raise("Terminated Marshal loading due to unknown indicator #{indicator.chr} (#{indicator})")

		end
	end

end