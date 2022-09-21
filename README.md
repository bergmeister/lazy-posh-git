# lazy-posh-git

## Summary

PowerShell proxy command around [Set-Location](https://docs.microsoft.com/powershell/module/microsoft.powershell.management/set-location) and therefore its built-in aliases `cd`, `chdir` and `sl` to defer import of [posh-git](https://github.com/dahlbyk/posh-git) module until one changes working directory to the root of a git directory. This is useful to speed up PowerShell startup time to not having to import `posh-git` module itself in the profile.

## Usage

Install the module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/lazy-posh-git/):

```powershell
Install-Module -Name 'lazy-posh-git' -AllowClobber
```

Then add this line into your PowerShell `$PROFILE`:

```powershell
Import-Module 'lazy-posh-git'
```

Only once you navigate to a git directory, the `posh-git` module will be imported, which is when it is needed, therefore defering the delay caused by the import to the last moment in time until we know we need it.

## Using custom posh-git settings or running a custom script after import

If there are certain `posh-git` settings you wish to change after `posh-git` is imported or running a custom script after import, you can do so by passing the path to a script as the first argument to the `PoshGitSettingsScriptPath` parameter when importing `lazy-posh-git`:

```powershell
Import-Module 'lazy-posh-git' -ArgumentList '~\path-to-my\git-prompt-settings.ps1'
``` 

`Lazy-posh-git` will run this script immediately after it has imported `posh-git`. The path can be absolute or relative depending on the assumptions you can make. Your script could look like this for example:

```powershell
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
$GitPromptSettings.AfterStatus.Text = "]`n"
```

## Support

Currently, this early version only supports PowerShell 7.0 and later. If you need support for PowerShell 5.1, please open an issue or open a pull request.

## How was it built and how does it work

This module was built by exporting creating the base of the proxy command with the following script:

```powershell
$metaData = New-Object System.Management.Automation.CommandMetaData(Get-Command Set-Location)
[System.Management.Automation.ProxyCommand]::Create($metadata)
```

This command is then wrapped in a function as `function{ }` and code added at the end of the `end` block of it to add the custom logic for importing `posh-git` if there is a `.git` folder in the current working directory.
```
