$apps = @(
    "01-ssr",
    "02-ssr-with-progressive-enhancement",
    "03-ssr-with-partial-dom-updates",
    "04-ssr-with-partial-csr",
    "05-csr-with-spa",
    "06-ssr-with-rehydration"
)

$maxLength = ($apps | Measure-Object -Maximum -Property Length).Maximum;

for ($i = 1; $i -le 6; $i++) {
    $app = $apps[$i - 1]
    $appName = $app.PadRight($maxLength + 2)
    $url = "https://todo-app-$i.holisticon.de/"
    Write-Host "$appName 🌍 $url"
    Start-Process $url
}