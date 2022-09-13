<#
    .ForwardHelpTargetName Microsoft.PowerShell.Management\Set-Location
    .ForwardHelpCategory Cmdlet
#>
function Set-Location {
    [CmdletBinding(DefaultParameterSetName = 'Path', HelpUri = 'https://go.microsoft.com/fwlink/?LinkID=2097049')]
    param(
        [Parameter(ParameterSetName = 'Path', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        ${Path},

        [Parameter(ParameterSetName = 'LiteralPath', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('PSPath', 'LP')]
        [string]
        ${LiteralPath},

        [switch]
        ${PassThru},

        [Parameter(ParameterSetName = 'Stack', ValueFromPipelineByPropertyName = $true)]
        [string]
        ${StackName})


    dynamicparam {
        try {
            $targetCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Management\Set-Location', [System.Management.Automation.CommandTypes]::Cmdlet, $PSBoundParameters)
            $dynamicParams = @($targetCmd.Parameters.GetEnumerator() | Microsoft.PowerShell.Core\Where-Object { $_.Value.IsDynamic })
            if ($dynamicParams.Length -gt 0) {
                $paramDictionary = [Management.Automation.RuntimeDefinedParameterDictionary]::new()
                foreach ($param in $dynamicParams) {
                    $param = $param.Value

                    if (-not $MyInvocation.MyCommand.Parameters.ContainsKey($param.Name)) {
                        $dynParam = [Management.Automation.RuntimeDefinedParameter]::new($param.Name, $param.ParameterType, $param.Attributes)
                        $paramDictionary.Add($param.Name, $dynParam)
                    }
                }

                return $paramDictionary
            }
        }
        catch {
            throw
        }
    }

    begin {
        try {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer)) {
                $PSBoundParameters['OutBuffer'] = 1
            }

            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Management\Set-Location', [System.Management.Automation.CommandTypes]::Cmdlet)
            $scriptCmd = { & $wrappedCmd @PSBoundParameters }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($PSCmdlet)
        }
        catch {
            throw
        }
    }

    process {
        try {
            $steppablePipeline.Process($_)
        }
        catch {
            throw
        }
    }

    end {
        try {
            $steppablePipeline.End()
        }
        catch {
            throw
        }
        if (Test-Path (Join-Path $PWD.Path '.git')) {
            Import-Module posh-git
        }
    }

}
