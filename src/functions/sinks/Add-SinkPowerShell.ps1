class PowerShellSink {

	[Serilog.Formatting.ITextFormatter]$TextFormatter

	[ValidateNotNullOrEmpty()][string]$OutputTemplate

	[Serilog.Core.Logger]$DefaultLoggerImpl = [Serilog.LoggerConfiguration]::new().CreateLogger()

	[Serilog.Events.LogEventLevel]$RestrictedToMinimumLevel = [Serilog.Events.LogEventLevel]::Verbose

	PowerShellSink(
		[string]$outputTemplate,
		[Serilog.Events.LogEventLevel]$restrictedToMinimumLevel = [Serilog.Events.LogEventLevel]::Verbose
	) {
		$this.OutputTemplate = $outputTemplate
		$this.RestrictedToMinimumLevel = $restrictedToMinimumLevel
		$this.TextFormatter = [Serilog.Formatting.Display.MessageTemplateTextFormatter]::new($outputTemplate)
	}
}

function Add-SinkPowerShell {
	<#
	.SYNOPSIS
		Writes log events to powershell host
	.DESCRIPTION
		Writes log events to powershell host
	.PARAMETER LoggerConfig
		Instance of LoggerConfiguration
	.PARAMETER OutputTemplate
		A message template describing the format used to write to the sink.
	.INPUTS
		Instance of LoggerConfiguration
	.OUTPUTS
		LoggerConfiguration object allowing method chaining
	.EXAMPLE
		PS> Add-SinkPowerShell
	.EXAMPLE
		PS> Add-SinkPowerShell -OutputTemplate "[{EnvironmentUserName}{MachineName} {Timestamp:HH:mm:ss} {Level:u3}] {Message:lj}{NewLine}{Exception}"
	#>

	[Cmdletbinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		[Serilog.LoggerConfiguration]$LoggerConfig,
		[Parameter(Mandatory = $false)]
		[string]$OutputTemplate = '{Message:lj}',
		[Parameter(Mandatory = $false)]
		[Serilog.Events.LogEventLevel]$RestrictedToMinimumLevel = [Serilog.Events.LogEventLevel]::Verbose
	)

	process {	
		$global:PowerShellSink = [PowerShellSink]::new($OutputTemplate, $RestrictedToMinimumLevel)

		$LoggerConfig
	}
}