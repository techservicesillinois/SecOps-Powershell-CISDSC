
deps:
	pwsh ./tools/install_dependencies.ps1

# TODO: May need apt-get -y update
linux_deps:
	echo "This command requires sudo"
	apt-get install -y --no-install-recommends libgdiplus libc6-dev

# TODO: depends on 'deps'
resource_changes:
	pwsh ./tools/generate_resources_changes.ps1

test_pester:
	pwsh -CommandWithArgs "Invoke-Pester"
test_debug:
	invoke-pester -TagFilter Debug -Output Diagnostic