class SceneDummy < SDC::Scene

	def update
		Emulation.gosu_game.update
		Emulation.tick_frame
	end

	def draw
		Emulation.gosu_game.draw
	end

	def handle_event(event)
		if event.has_type?(:KeyPressed) then
			Emulation.gosu_game.button_down(event.key_code)
			if event.key_code == SDC::EventKey::R then
				Emulation.gosu_game.text_input.text = "HDWK" if Emulation.gosu_game.text_input
			end

		elsif event.has_type?(:Closed)
			puts "Terminating..."
			SDC.next_scene = nil

		end
	end

end
