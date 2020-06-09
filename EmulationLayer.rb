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
				SDC.process_text_input(event: event, text_buffer: Emulation.gosu_game.text_input.text)
			end

		elsif event.has_type?(:KeyPressed) then
			Emulation.gosu_game.button_down(event.key_code)

		elsif event.has_type?(:Closed)
			SDC.next_scene = nil

		end
	end

end
