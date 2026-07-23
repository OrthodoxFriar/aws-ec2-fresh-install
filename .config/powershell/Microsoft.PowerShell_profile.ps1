# Minimal PowerShell 7 profile for Linux
# Location: $PROFILE

# Simple, clean prompt (optional – remove if you prefer the default)
function prompt {
    "PS $($PWD.Path.Replace($HOME, '~'))$('>' * ($nestedPromptLevel + 1)) "
}

# Handy short function (example)
function ll {
    Get-ChildItem -Force @args
}

# You can add more functions or Set-Alias statements below
