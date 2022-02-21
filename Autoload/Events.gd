extends EventsBase

# warnings-disable

signal OBS_scene_changed(previous_scene_name, new_scene_name)
signal raid(channel_name, nb_raiders)
signal alert(alert_name)

signal new_follower(follower_name)
signal new_subscriber(subscriber_name, tier, nb_months, with_prime)
signal sub_gift(gifter_name, nb_sub_gifted)
signal new_donation(donater_name, donation_type, amount)

signal send_query(query)
