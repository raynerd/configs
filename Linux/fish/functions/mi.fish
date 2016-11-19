function mi --description 'show midhtnight commander info'
	set -l mocinfo (mocp -Q '%state\n%title\n%artist\n%ct\n%tt' ^/dev/null)
	set -l moc_state ''
	if test "$mocinfo"
		switch "$mocinfo[1]"
		case PLAY
			set moc_state '▶'
		case PAUSE
			set moc_state '▮▮'
		case STOP
			set moc_state '■'
		end
		echo (set_color -b white black)" $moc_state "$mocinfo[2]" by "$mocinfo[3]" "$mocinfo[4]" of "$mocinfo[5](set_color -b black white)
	else
		echo (set_color -b red)'✗'(set_color normal)' Moc is not running'

	end
end
