
deps:
	pwsh ./tools/install_dependencies.ps1

# TODO: depends on 'deps'
resource_changes:
	pwsh ./tools/generate_resources_changes.ps1