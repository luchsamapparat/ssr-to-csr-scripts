param(
    [bool] $Detach = $false
)

$backendApps = @(
    "01-ssr",
    "02-ssr-with-progressive-enhancement",
    "03-ssr-with-partial-dom-updates",
    "04-ssr-with-partial-csr",
    "05-csr-with-spa",
    "06-ssr-with-rehydration"
)
    
$frontendApps = @(
    "06-ssr-with-rehydration"
)

try
{
    $backendPort = 8081;
    foreach ($app in $backendApps) {
        $jarPath = ".\$app\target\todo-app-0.0.1-SNAPSHOT.jar"
        Start-Job -Name "$app-backend" -Scriptblock { java -jar $Using:jarPath --server.port=$Using:backendPort }
        $backendPort++;
    }

    $frontendPort = 9001;
    foreach ($app in $frontendApps) {
        $workingDirectory = "$pwd\$app\src\main\frontend"
        Start-Job -Name "$app-frontend" -Scriptblock { Set-Location $Using:workingDirectory; npm start -- --port=$Using:frontendPort }
        $frontendPort++;
    }
    
    if (!$Detach) {
        ./logs.ps1
    }
}
finally
{
    if (!$Detach) {
        ./stop.ps1
    }
}