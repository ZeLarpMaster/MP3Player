note
	description: "Class containing information about a music file"
	author: "Guillaume Jean"
	date: "Wed, 15 Feb 2017 19:17:25 +0000"
	revision: "0.1"

class
	SONG

create
	make_from_string,
	make_from_path

feature {NONE} -- Initialization

	make
			-- Initializes `Current's default values
		do
			create error.make
		end

	make_from_string(a_file: READABLE_STRING_GENERAL)
			-- Initializes `Current' with the file found at `a_string'
		do
			make
			file_path := a_file
		end

	make_from_path(a_path: PATH)
			-- Initializes `Current' with the file found at `a_path'
		do
			make_from_string(a_path.name)
		end

feature {ANY} -- Access

	is_valid: BOOLEAN
			-- Checks whether or not the sound file is a valid and supported sound file
		local
			l_sound: detachable METADATA_AUDIO_SOUND
		do
			l_sound := get_audio_sound
			Result := error.is_no_error
		end

	is_loaded: BOOLEAN
			-- Checks whether or not the sound file is loaded
		do
			Result := attached sound as la_sound and then la_sound.is_open
		end

	load
			-- Opens the sound file
		do
			sound := get_audio_sound
		end

	fetch_song_information
			-- Gathers metadata about the song file
		do
			if attached {MPG_SOUND_FILE} sound as la_mpg then
				la_mpg.scan
			end
			if attached sound as la_sound then
				album := la_sound.album
				artist := la_sound.artist
				comment := la_sound.comment
				date := la_sound.date
				genre := la_sound.genre
				title := la_sound.title
			end
		end

	error: ERROR_CODE
			-- `Current's error code

	file_path: READABLE_STRING_GENERAL
			-- Path to the song file

	sound: detachable METADATA_AUDIO_SOUND
			-- Audio data of `Current'

	album: detachable READABLE_STRING_GENERAL
			-- Album metadata of the sound file

	artist: detachable READABLE_STRING_GENERAL
			-- Artist metadata of the sound file

	comment: detachable READABLE_STRING_GENERAL
			-- Comment metadata of the sound file

	date: detachable READABLE_STRING_GENERAL
			-- Date metadata of the sound file

	genre: detachable READABLE_STRING_GENERAL
			-- Genre metadata of the sound file

	title: detachable READABLE_STRING_GENERAL
			-- Title metadata of the sound file

feature {NONE} -- Implementation

	get_audio_sound: detachable METADATA_AUDIO_SOUND
			-- Returns the appropriate {AUDIO_SOUND} implementation for `a_file'
		local
			l_audio: AUDIO_SOUND_FILE
			l_mp3: MPG_SOUND_FILE
		do
			create l_mp3.make(file_path)
			if l_mp3.is_openable then
				l_mp3.open
				if l_mp3.is_open then
					Result := l_mp3
				end
			end
			if not attached Result then
				create l_audio.make(file_path)
				if l_audio.is_openable then
					l_audio.open
					if l_audio.is_open then
						Result := l_audio
					end
				end
			end
			if not attached Result then
				error.set_unsupported_format_error
			elseif attached Result as la_result and then not la_result.is_open then
				error.set_loading_audio_error
			end
		end

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
