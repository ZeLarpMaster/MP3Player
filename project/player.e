note
	description: "Control and play the music"
	author: "Louis Marchand"
	date: "Thu, 26 Jan 2017 00:42:10 +0000"
	revision: "0.1"

class
	PLAYER

inherit
	AUDIO_LIBRARY_SHARED
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- Initialization of `Current'
		do
			create error.make
			audio_library.sources_add
			source := audio_library.last_source_added
			if not source.is_open then
				error.set_source_closed_error
			end
			create {LINKED_LIST[READABLE_STRING_GENERAL]} song_list.make
			create {LINKED_QUEUE[READABLE_STRING_GENERAL]} song_dispenser.make
		end

feature {ANY} -- Access

	add_file(a_file: READABLE_STRING_GENERAL)
			-- Add `a_file' to the `song_list'
		do
			song_list.extend(a_file)
		end

	add_folder(a_folder: READABLE_STRING_GENERAL)
			-- Recursively open files in `a_folder' and it's sub-folders into `play_list'
		local
			l_path: PATH
			l_folder: DIRECTORY
			l_file: RAW_FILE
		do
			create l_path.make_from_string(a_folder)
			create l_folder.make_with_path(l_path)
			across l_folder.entries as la_entries loop
				if not (la_entries.item.is_current_symbol or la_entries.item.is_parent_symbol) then
					create l_file.make_with_path(l_path.extended(la_entries.item.name))
					if l_file.is_directory then
						add_folder(l_path.extended(la_entries.item.name).name)
					elseif is_supported_audio_file(l_path.extended(la_entries.item.name).name) then
						song_list.extend(l_path.extended(la_entries.item.name).name)
					end
				end
			end
		end

	play
			-- Resume (or start) playing the `music'
		do
			if source.sound_queued.is_empty then
				next_song
			end
			source.play
		end

	stop
			-- Completely stop playing the `music'
		do
			source.stop
		end

	pause
			-- Temporarly stop playing the `music'
		do
			source.pause
		end

	next
			-- Move to the next song
		do
			next_song
		end

	toggle_random
			-- Toggles the randomness of `song_dispenser'
		do
			if attached {RANDOM_BAG[READABLE_STRING_GENERAL]} song_dispenser then
				create {LINKED_QUEUE[READABLE_STRING_GENERAL]} song_dispenser.make
			else
				create {RANDOM_BAG[READABLE_STRING_GENERAL]} song_dispenser.make(song_list.count)
			end
			refill_dispenser
		end

	update
			-- Update the audio `source'
		do
			source.update_playing
		end

feature {NONE} -- Implementation

	is_supported_audio_file(a_file: READABLE_STRING_GENERAL): BOOLEAN
			-- Check whether or not `a_file' is a supported audio file
		local
			l_audio: AUDIO_SOUND_FILE
			l_mp3: MPG_SOUND_FILE
		do
			Result := False
			create l_audio.make(a_file)
			if l_audio.is_openable then
				l_audio.open
				Result := l_audio.is_open
			end
			if not Result then
				create l_mp3.make(a_file)
				if l_mp3.is_openable then
					l_mp3.open
					Result := l_mp3.is_open
				end
			end
		end

	refill_dispenser
			-- Refills `song_dispenser' with songs taken from `song_list'
		do
			song_dispenser.fill(song_list)
		end

	next_song
			-- Move to the next song in the `song_dispenser'
		do
			if song_dispenser.is_empty then
				refill_dispenser
			else
				song_dispenser.remove
			end
			create song_file.make(song_dispenser.item)
			if attached song_file as la_song_file and then la_song_file.is_openable then
				la_song_file.open
				if not la_song_file.is_open then
					error.set_loading_audio_error
				else
					source.queue_sound(la_song_file)
				end
			else
				error.set_loading_audio_error
			end
		end

	song_dispenser: DISPENSER[READABLE_STRING_GENERAL]
			-- Dispenser of songs to play

	song_list: LINKED_LIST[READABLE_STRING_GENERAL]
			-- The list of all music files to play

	source: AUDIO_SOURCE
			-- The source of audio

	song_file: detachable AUDIO_SOUND_FILE
			-- The current audio sound file

	error: ERROR_CODE
			-- The current error code of `Current'

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
