note
	description: "Control and play the music"
	author: "Louis Marchand"
	date: "Thu, 26 Jan 2017 00:42:10 +0000"
	revision: "0.1"

class
	PLAYER

inherit
	THREAD
		rename
			launch as launch_thread,
			join as join_thread
		redefine
			default_create
		end
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
			make
			audio_library.sources_add
			source := audio_library.last_source_added
			create {LINKED_LIST[READABLE_STRING_GENERAL]} play_list.make
			create mutex.make
		end

feature {ANY} -- Access

	add_file(a_file:READABLE_STRING_GENERAL)
			-- Open `a_file' in `music'
		do
			mutex.lock
			play_list.extend(a_file)
			mutex.unlock
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

	stop_thread
			-- Stop the {THREAD} of `Current'
		do
			must_stop := True
		end

	must_stop:BOOLEAN
			-- The {THREAD} of `Current' have to stop

feature {NONE} -- Implementation

	execute
			-- <Precursor>
		local
			l_environment:EXECUTION_ENVIRONMENT
		do
			create l_environment
			from
				must_stop := False
			until
				must_stop
			loop
				if not attached music then
					play_next_music
				end
				audio_library.update
				l_environment.sleep (10000000)
			end
		end

	play_next_music
			-- Get the next sound from `play_list' and put it in `music'
		do
			mutex.lock

			mutex.unlock
		end

	source:AUDIO_SOURCE
			-- The source of audio

	mutex:MUTEX
			-- Manage the {THREAD} synchronisation

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
