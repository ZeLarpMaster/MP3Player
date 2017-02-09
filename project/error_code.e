note
	description: "Facade for the error codes"
	author: "Guillaume Jean"
	date: "Wed, 08 Feb 2017 21:18:57 +0000"
	revision: "0.1"

class
	ERROR_CODE

create
	make

feature {NONE} -- Initialization

	make
			-- Initializes `Current' with no error
		do
			set_no_error
		end

feature {ANY} -- Access

	set_no_error
			-- Sets `Current' to represent no error
		do
			internal_error_code := 0
		end

	set_loading_audio_error
			-- Sets `Current' to represent an error while loading an audio file
		do
			internal_error_code := 1
		end

	set_source_closed_error
			-- Sets `Current' to represent the audio source isn't open
		do
			internal_error_code := 2
		end

	is_no_error: BOOLEAN
			-- Whether or not `Current' means no error
		do
			Result := internal_error_code = 0
		end

	is_loading_audio_error: BOOLEAN
			-- Whether or not `Current' means an error while loading an audio file
		do
			Result := internal_error_code = 1
		end

	is_source_closed_error: BOOLEAN
			-- Whether or not `Current' meanst the audio source isn't open
		do
			Result := internal_error_code = 2
		end

feature {NONE} -- Implementation

	internal_error_code: INTEGER
			-- Number representing the current error code

invariant


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
