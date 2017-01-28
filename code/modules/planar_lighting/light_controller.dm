/*
var/datum/controller/process/lights/lights_master
var/list/init_turfs = list()
var/list/init_lights = list()

///datum/var/gcDestroyed
/*
/proc/deleted(atom/A)
	return !A || !isnull(A.gcDestroyed)
*/
/datum/controller/process/lights
	var/list/queued_lights = list()

/datum/controller/process/lights/setup()
	name = "lights"
	schedule_interval = 10 // Until it is actually used for casting rather than roundstart this is unneeded
	lights_master = src
	if(init_lights && init_lights.len)
		queued_lights += init_lights

/datum/controller/process/lights/statProcess()
	..()
	stat(null, "[queued_lights.len] queued")

/datum/controller/process/lights/doWork()
	for(var/thing in queued_lights)
		var/obj/effect/light/L = thing
		queued_lights -= L
		if(L && !deleted(L))
			world << "свет2"
			L.cast_light()
		SCHECK

/datum/controller/process/lights/proc/queue_light(var/obj/effect/light/light)
	queued_lights |= light
*/
/*
var/datum/controller/process/lights/lights_master
var/list/init_turfs = list()
var/list/init_lights = list()

/datum/controller/process/lights
	var/list/queued_lights = list()

/datum/controller/process/lights/setup()
	name = "lights"
	schedule_interval = 10 // Until it is actually used for casting rather than roundstart this is unneeded
	lights_master = src
	if(init_lights && init_lights.len)
		queued_lights += init_lights

/datum/controller/process/lights/doWork()
	for(var/thing in queued_lights)
		var/obj/effect/light/L = thing
		queued_lights -= L
		if(L && !deleted(L))
			L.cast_light()

/datum/controller/process/lights/proc/queue_light(var/obj/effect/light/light)
	queued_lights |= light
*/