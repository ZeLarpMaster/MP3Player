note
	description: "EiffelVision Widget MAIN_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	generator: "EiffelBuild"
	date: "$Date: 2010-12-22 10:39:24 -0800 (Wed, 22 Dec 2010) $"
	revision: "$Revision: 85202 $"

class
	MAIN_WINDOW

inherit
	MAIN_WINDOW_IMP


feature {NONE} -- Initialization

	user_create_interface_objects
			-- Create any auxilliary objects needed for MAIN_WINDOW.
			-- Initialization for these objects must be performed in `user_initialization'.
		do
				-- Create attached types defined in class here, initialize them in `user_initialization'.
				create player
				player.add_folder("D:\Musique Test")
		end

	user_initialization
			-- Perform any initialization on objects created by `user_create_interface_objects'
			-- and from within current class itself.
		do
				-- Initialize types defined in current class
				open_button.set_pixmap ((create {OPEN_PIXEL_BUFFER}.make).to_pixmap)
				play_button.set_pixmap ((create {PLAY_PIXEL_BUFFER}.make).to_pixmap)
				next_button.set_pixmap ((create {NEXT_PIXEL_BUFFER}.make).to_pixmap)
				previous_button.set_pixmap ((create {PREVIOUS_PIXEL_BUFFER}.make).to_pixmap)
				pause_button.set_pixmap ((create {PAUSE_PIXEL_BUFFER}.make).to_pixmap)
				shuffle_button.set_pixmap ((create {SHUFFLE_PIXEL_BUFFER}.make).to_pixmap)
		end

feature {NONE} -- Implementation


	progress_range_change_actions (a_value: INTEGER)
			-- Called by `change_actions' of `progress_range'.
		do
		end


	open_button_select_actions
			-- Called by `select_actions' of `open_button'.
		do
		end


	previous_button_select_actions
			-- Called by `select_actions' of `previous_button'.
		do
		end


	play_button_select_actions
			-- Called by `select_actions' of `play_button'.
		do
		end


	pause_button_select_actions
			-- Called by `select_actions' of `pause_button'.
		do
		end


	next_button_select_actions
			-- Called by `select_actions' of `next_button'.
		do
		end


	volume_range_change_actions (a_value: INTEGER)
			-- Called by `change_actions' of `volume_range'.
		do
		end

	shuffle_button_select_actions
			-- Called by `select_actions` of shuffle_button.
		do
		end

	player: PLAYER
			-- The sound manager and playlist holder

end
