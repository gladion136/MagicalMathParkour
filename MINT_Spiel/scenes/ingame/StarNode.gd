extends Control

func set_star_count(starcount, outof):
	$StarsCollected.text = str(starcount) + " / " + str(outof)
