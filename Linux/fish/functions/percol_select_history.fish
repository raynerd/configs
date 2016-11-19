function percol_select_history
	history|percol --query (commandline) |read foo
  if [ $foo ]
    commandline $foo
  else
    commandline ''
  end
end


