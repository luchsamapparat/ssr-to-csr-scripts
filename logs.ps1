$colors = @{
    "01-ssr" = "Gray";
    "02-ssr-with-progressive-enhancement" = "Blue";
    "03-ssr-with-partial-dom-updates" = "Yellow";
    "04-ssr-with-partial-csr" = "Magenta";
    "05-csr-with-spa" = "Red";
    "06-ssr-with-rehydration" = "Green";
}

while((Get-Job -State Running).count -gt 0){
    Get-Job
        | Where-Object { $_.HasMoreData }
        | ForEach-Object {
            $log = Invoke-Command -ScriptBlock { Receive-Job $_ | Out-String }

            if ($log) {
                $name = $_.Name.Replace("-frontend", "").Replace("-backend", "")
                $isFrontend = $_.Name.EndsWith("-frontend");
                $icon = If ($isFrontend) { "🍺" } Else { "☕" }
                Write-Host "$icon [$name]: $log" -ForegroundColor $colors[$name]
            }
        }
    Start-Sleep -Seconds 1
}