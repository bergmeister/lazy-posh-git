# lazy-posh-git

## Summary

A PowerShell proxy command around [`Set-Location`](https://docs.microsoft.com/powershell/module/microsoft.powershell.management/set-location) &ndash; and thus its built-in aliases `cd`, `chdir`, and `sl` &ndash; to defer import of the [posh-git](https://github.com/dahlbyk/posh-git) module until one changes the working directory to the root of a git directory. This is useful for speeding up PowerShell startup times so that one does not have to import the `posh-git` module itself from the profile.

## Usage

Install the module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/lazy-posh-git/):

```powershell
Install-Module -Name 'lazy-posh-git' -AllowClobber
```

Then add this line to your PowerShell `$PROFILE`:

```powershell
Import-Module 'lazy-posh-git'
```

Only once you navigate to a git directory is the `posh-git` module imported, thereby defering the delay caused by the import to when it is actually needed.

## Using custom posh-git settings or running a custom script after import

If there are certain `posh-git` settings you wish to change after it is imported or when running a custom script after import, you can pass the path to a script as the first argument to the `PoshGitSettingsScriptPath` parameter when importing `lazy-posh-git`:

```powershell
Import-Module 'lazy-posh-git' -ArgumentList '~/path-to-my/git-prompt-settings.ps1'
``` 

`lazy-posh-git` will run this script immediately after it has imported `posh-git`. The path could be absolute or relative, depending on the assumptions you can make. For example, your script could look like this:

```powershell
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
$GitPromptSettings.AfterStatus.Text = "]`n"
```

## How it was built and how it works

This module was built by exporting creating the base of the proxy command with the following script:

```powershell
$metaData = New-Object System.Management.Automation.CommandMetaData(Get-Command Set-Location)
[System.Management.Automation.ProxyCommand]::Create($metadata)
```

This command is then wrapped in a function as `function{ }` and code added at the end of its `end` block to add the custom logic for importing `posh-git` if there is a `.git` folder in the current working directory.

## Support

This early version works for PowerShell 5.1 and 7. If you need support for older versions, please open an issue or a pull request.
