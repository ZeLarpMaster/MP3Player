note
	description: "Game2 root class to initialize and close internal libraries"
	author: "Louis Marchand"
	date: "Thu, 26 Jan 2017 00:42:10 +0000"
	revision: "1.0"

class
	GAME2_APPLICATION

inherit
	AUDIO_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization of the external libraries and launch the {APPLICATION}
		local
			l_application:detachable VISION2_APPLICATION
			l_memory:MEMORY
		do
			audio_library.enable_sound
			create l_application.make_and_launch
			l_application := Void
			create l_memory
			l_memory.full_collect
			audio_library.quit_library
		end

note
	License: "[
    			A simple music player
    			Copyright (C) 2017  Louis M and Ze Larp Master

			    This program is free software: you can redistribute it and/or modify
			    it under the terms of the GNU General Public License as published by
			    the Free Software Foundation, either version 3 of the License, or
			    (at your option) any later version.

			    This program is distributed in the hope that it will be useful,
			    but WITHOUT ANY WARRANTY; without even the implied warranty of
			    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
			    GNU General Public License for more details.

			    You should have received a copy of the GNU General Public License
				along with this program. If not, see <http://www.gnu.org/licenses/>.
			]"
end
