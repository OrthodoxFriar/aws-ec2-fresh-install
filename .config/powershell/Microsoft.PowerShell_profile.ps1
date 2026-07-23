# Minimal PowerShell 7 profile for Linux
# Location: $PROFILE

# Custom Prompt indicates server
function prompt {
    $path = $PWD.Path.Replace($HOME, '~')
    $hostname = [System.Net.Dns]::GetHostName()

    # Show [remote@hostname] only when connected via SSH
    $remote = if ($env:SSH_CLIENT -or $env:SSH_CONNECTION) {
        "[remote@$hostname] "
    } else {
        ""
    }

    "PS $remote$path$('>' * ($nestedPromptLevel + 1)) "
}

# Handy short function (example)
function ll {
    Get-ChildItem -Force @args
}

# You can add more functions or Set-Alias statements below
