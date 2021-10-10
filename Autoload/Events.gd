extends EventsBase

# warnings-disable

signal OBS_scene_changed(previous_scene_name, new_scene_name)
signal raid(channel_name, nb_raiders)
signal alert(alert_name)

signal send_query(query)
