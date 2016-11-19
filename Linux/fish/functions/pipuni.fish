function pipuni
	pip freeze  | sed 's-==.*--g'  | percol  | read uni
	pip uninstall $uni
end
