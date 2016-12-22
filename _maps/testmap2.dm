#if !defined(MAP_FILE)

        #include "map_files\Stalker\old\testmap2.dmm"

        #define MAP_FILE "testmap2.dmm"
        #define MAP_NAME "testmap2"
		#define MAP_TRANSITION_CONFIG list(MAIN_STATION = CROSSLINKED, CENTCOMM = SELFLOOPING)
#elif !defined(MAP_OVERRIDE)

	#warn a map has already been included, ignoring testmap2.dmm.

#endif