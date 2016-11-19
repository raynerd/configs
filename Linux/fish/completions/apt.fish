#completion for apt 
# by raven

function __raven_apt_no_subcommand  --description 'Test if apt has yet to be given the subcommand'
	for i in (commandline -opc)
		if contains -- $i list search show install  remove edit-sources update upgrade full-upgrade purge help
			return 1
		end
	end
	return 0
end

function __raven_apt_use_package  --description 'Test if apt command should have packages as potential completion'
	for i in (commandline -opc)
		if contains -- $i full-upgrade purge install remove upgrade show
			return 0
		end
	end
	return 1
end

complete -c apt -n '__raven_apt_use_package' -a '(__fish_print_packages)'  --description 'Package'

complete -c apt -s h -l help  --description 'Display a brief help message. Identical to the help action'

complete -f -n '__raven_apt_no_subcommand' -c apt -a 'list'  --description 'Display a list of packages'
complete -f -n '__raven_apt_no_subcommand' -c apt -a 'update'  --description 'Update the list of available packages from the apt sources'
complete -f -n '__raven_apt_no_subcommand' -c apt -a 'full-upgrade'  --description 'Upgrade, removing or installing packages as necessary'
complete -f -n '__raven_apt_no_subcommand' -c apt -a 'install'  --description 'Install the packages'
complete -f -n '__raven_apt_no_subcommand' -c apt -a 'purge'  --description 'Remove and delete all associated configuration and data files'
complete -f -n '__raven_apt_no_subcommand' -c apt -a 'remove'  --description 'Remove the packages'
complete -f -n '__raven_apt_no_subcommand' -c apt -a 'show'  --description 'Display detailed information about the packages'
complete -f -n '__raven_apt_no_subcommand' -c apt -a 'search'  --description 'Search for packages matching one of the patterns'
complete -f -n '__raven_apt_no_subcommand' -c apt -a 'help'  --description 'Display brief summary of the available commands and options'

