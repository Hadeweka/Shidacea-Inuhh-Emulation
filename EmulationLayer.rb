class SceneDummy < SDC::Scene

	def update
		SDC.text_input = Emulation.gosu_game.text_input
		Emulation.gosu_game.update
		Emulation.tick_frame
	end

	def draw
		Emulation.gosu_game.draw
	end

	def handle_event(event)
		if event.has_type?(:TextEntered) then
			if Emulation.gosu_game.text_input then
				char = event.text_char
				if char == "\n" then

				elsif char == "\r" then

				elsif char == "\t" then

				elsif char == "\b" then
					Emulation.gosu_game.text_input.text.chop!
				elsif char == "\x7F" then
					# Remove the last word and every whitespace after it
					Emulation.gosu_game.text_input.text.rstrip!
					last_space = Emulation.gosu_game.text_input.text.rindex(" ")
					if last_space then
						Emulation.gosu_game.text_input.text = Emulation.gosu_game.text_input.text[0..last_space]
					else
						Emulation.gosu_game.text_input.text = ""
					end
				else
					Emulation.gosu_game.text_input.text += event.text_char if Emulation.gosu_game.text_input
				end
			end

		elsif event.has_type?(:KeyPressed) then
			Emulation.gosu_game.button_down(event.key_code)

		elsif event.has_type?(:Closed)
			puts "Terminating..."
			SDC.next_scene = nil

		end
	end

end
