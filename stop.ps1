Get-Job
    | Where-Object { $_.State -eq 'Running' }
    | ForEach-Object {
        Stop-Job $_
        Remove-Job $_
    }