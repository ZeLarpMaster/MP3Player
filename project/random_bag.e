note
	description: "A bag fetching random items"
	author: "Guillaume Jean"
	date: "Wed, 08 Feb 2017 18:57:10 +0000"
	revision: "0.1"

class
	RANDOM_BAG [G]

inherit
	DISPENSER [G]
		redefine
			item
		end

create
	make

feature {NONE} -- Initialization

	make(a_size: INTEGER)
			-- Initialization of an empty `Current'
		local
			l_date_time: DATE_TIME
		do
			create l_date_time.make_now_utc
			create internal_list.make(a_size)
			create ordering.set_seed(l_date_time.days * l_date_time.seconds_in_day + l_date_time.seconds)
		end

feature {ANY} -- Access

	force (v: like item)
			-- <Precursor>
		do
			internal_list.force(v)
			forth
		end

	extend (v: like item)
			-- <Precursor>
		do
			internal_list.extend(v)
			forth
		end

	put (v: like item)
			-- <Precursor>
		do
			internal_list.put(v)
		end

	replace (v: like item)
			-- <Precursor>
		do
			internal_list.replace(v)
		end

	remove
			-- <Precursor>
		do
			internal_list.remove
			forth
		end

	occurrences (v: like item): INTEGER
			-- <Precursor>
		do
			Result := internal_list.occurrences(v)
		end

	extendible: BOOLEAN
			-- <Precursor>
		do
			Result := internal_list.extendible
		end

	prunable: BOOLEAN
			-- <Precursor>
		do
			Result := internal_list.prunable
		end

	prune (v: like item)
			-- <Precursor>
		do
			internal_list.prune(v)
			forth
		end

	wipe_out
			-- <Precursor>
		do
			internal_list.wipe_out
		end

	has (v: G): BOOLEAN
			-- <Precursor>
		do
			Result := internal_list.has(v)
		end

	linear_representation: LINEAR [G]
			-- <Precursor>
		do
			Result := internal_list
		end

	count: INTEGER
			-- <Precursor>
		do
			Result := internal_list.count
		end

	full: BOOLEAN
			-- <Precursor>
		do
			Result := internal_list.full
		end

	item: G
			-- <Precursor>
		do
			Result := internal_list.item
		end

feature	{NONE} -- Implementation

	forth
			-- Go to the next `item'
		do
			ordering.forth
			if not internal_list.is_empty then
				internal_list.go_i_th((ordering.item \\ internal_list.count) + 1)
			end
		end

	internal_list: ARRAYED_LIST[G]
			-- List of elements in `Current'

	ordering: RANDOM
			-- Ordering of the elements of `internal_list'

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
