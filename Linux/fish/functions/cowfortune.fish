function cowfortune --description 'random fortune in a random cowsay'
	set cows apt cock default elephant head-in hellokitty koala luke-koala moofasa moose mutilated pony-smaller sheep skeleton snowman sodomized-sheep suse tux vader unipony-smaller vader-koala www
	set cow $cows[(math (random)%(count $cows)+1)]
	cowthink -f $cow (fortune -s)
end
