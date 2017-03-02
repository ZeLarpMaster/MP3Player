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
			audio_library.set_sound_buffer_size(262144)
			audio_library.sources_add
			source := audio_library.last_source_added
			if not source.is_open then
				error.set_source_closed_error
			end
			create playing_song_list.make
			create {LINKED_LIST[SONG]} original_song_list.make
			create {LINKED_QUEUE[SONG]} song_dispenser.make
			create previous_songs.make
			create song_changes_actions
			is_playing := False
		end

feature {ANY} -- Access

	open_file(a_file: READABLE_STRING_GENERAL)
			-- Add `a_file' to the `original_song_list'
		do
			add_file(a_file)
		end

	add_folder(a_folder: READABLE_STRING_GENERAL)
			-- Recursively open files in `a_folder' and it's sub-folders into `original_song_list'
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
					else
						add_file(l_path.extended(la_entries.item.name).name)
					end
				end
			end
		end

	play
			-- Resume (or start) playing the `music'
		do
			if not source.is_playing then
				if source.sound_queued.is_empty then
					next_song
				end
				source.play
				is_playing := True
			end
		end

	stop
			-- Completely stop playing the `music'
		do
			source.stop
			is_playing := False
		end

	pause
			-- Temporarly stop playing the `music'
		do
			source.pause
			is_playing := False
		end

	next
			-- Move to the next song
		do
			source.stop
			if not song_dispenser.is_empty and not original_song_list.is_empty then
				next_song
				source.play
			end
		end

	previous
			-- Move to the last played song
		do
			if not previous_songs.is_empty then
				source.stop
				previous_song
				source.play
			end
		end

	set_gain(a_value: REAL_32)
			-- Set the gain of `source'
		do
			source.set_gain(a_value)
		end

	toggle_random
			-- Toggles the randomness of `song_dispenser'
		do
			if attached {RANDOM_BAG[SONG]} song_dispenser then
				song_dispenser := playing_song_list
			else
				create {RANDOM_BAG[SONG]} song_dispenser.make(original_song_list.count)
				refill_dispenser
			end
		end

	update
			-- Update the audio `source'
		do
			if is_playing then
				if source.is_open and not source.sound_queued.is_empty then
					source.update_playing
				end

				if not source.is_playing then
					if song_dispenser.is_empty then
						is_playing := False
					else
						next_song
						play
					end
					-- TODO: Remove the song if it has an error?
				end
			end
		end

	song_changes_actions: ACTION_SEQUENCE[TUPLE[SONG]]
			-- Called when `Current's song changes

	is_playing: BOOLEAN
			-- Whether or not the player should be currently playing

feature {NONE} -- Implementation

	add_file(a_file: READABLE_STRING_GENERAL)
			-- Initializes the song found at path `a_file'
		local
			l_song: SONG
		do
			create l_song.make_from_string(a_file)
			if l_song.is_valid then
				original_song_list.extend(l_song)
				playing_song_list.extend(l_song)
			else
				error.set_loading_audio_error
			end
		end

	refill_dispenser
			-- Refills `song_dispenser' with songs taken from `original_song_list'
		do
			song_dispenser.fill(original_song_list)
		end

	next_song
			-- Move to the next song in the `song_dispenser'
		do
			if not song_dispenser.is_empty then
				previous_songs.extend(song_dispenser.item)
				song_dispenser.remove
			end
			if song_dispenser.is_empty then
				refill_dispenser
			end
			if attached song_dispenser.item as la_song then
				if not la_song.is_loaded then
					la_song.load
				end
				if attached la_song.sound as la_sound then
					source.queue_sound(la_sound)
				end
				song_changes_actions.call(song_dispenser.item)
			else
				error.set_loading_audio_error
			end
		end

	previous_song
			-- Play the latest previously played song from `previous_songs'
		require
			SongsPlayedBefore: not previous_songs.is_empty
		do
			if attached previous_songs.item.sound as la_song_file and then la_song_file.is_open then
				source.queue_sound(la_song_file)
				song_changes_actions.call(previous_songs.item)
			end
			previous_songs.remove
		end

	previous_songs: LINKED_STACK[SONG]
			-- List of previously played songs

	song_dispenser: DISPENSER[SONG]
			-- Dispenser of songs to play

	playing_song_list: LINKED_QUEUE[SONG]
			-- The list of songs currently playing

	original_song_list: LINKED_LIST[SONG]
			-- The original list of all songs to play

	source: AUDIO_SOURCE
			-- The source of audio

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
