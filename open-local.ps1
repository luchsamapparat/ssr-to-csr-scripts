$ports = @{
    "01-ssr" = 8081;
    "02-ssr-with-progressive-enhancement" = 8082;
    "03-ssr-with-partial-dom-updates" = 8083;
    "04-ssr-with-partial-csr" = 8084;
    "05-csr-with-spa" = 8085;
    "06-ssr-with-rehydration" = 9001;
}

$maxLength = ($ports.Keys | Measure-Object -Maximum -Property Length).Maximum;

$apps = $ports.Keys | Sort-Object

foreach ($app in $apps) {
    $appName = $app.PadRight($maxLength + 2)
    $port = $ports[$app]
    $url = "http://localhost:$port"
    Write-Host "$appName 🌍 $url"
    Start-Process $url
}