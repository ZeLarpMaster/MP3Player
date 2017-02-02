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
			audio_library.sources_add
			source := audio_library.last_source_added
			create {LINKED_LIST[READABLE_STRING_GENERAL]} play_list.make
		end

feature {ANY} -- Access

	add_file(a_file:READABLE_STRING_GENERAL)
			-- Open `a_file' in `music'
		do
			play_list.extend(a_file)
		end

	play
			-- Resume (or start) playing the `music'
		do
			source.play
		end

	stop
			-- Completely stop playing the `music'
		do
			source.stop
		end

	pause
			-- Temporarry stop playing the `music'
		do
			source.pause
		end

	music: detachable AUDIO_SOUND
			-- What is presently played by `Current'

	play_list:LIST[READABLE_STRING_GENERAL]
			-- The list of all music file to play

feature {NONE} -- Implementation

	play_next_music
			-- Get the next sound from `play_list' and put it in `music'
		do
		end

	source:AUDIO_SOURCE
			-- The source of audio

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
