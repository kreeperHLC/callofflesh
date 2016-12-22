#if !defined(MAP_FILE)

		#include "map_files\Stalker\Zona\kordon1.dmm"
		#include "map_files\Stalker\Zona\kordon2.dmm"
		#include "map_files\Stalker\Zona\svalka.dmm"
		#include "map_files\Stalker\Zona\agroprom.dmm"

		#define MAP_FILE "kordon1.dmm"
		#define MAP_NAME "Zona"
		#define MAP_TRANSITION_CONFIG list(MAIN_STATION = CROSSLINKED, CENTCOMM = SELFLOOPING)
#elif !defined(MAP_OVERRIDE)

	#warn a map has already been included, ignoring kordon.dmm.

#endif