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

foreach ($app in $backendApps) {
    cd $app;
    mvn clean install -DskipTests;
    cd..;
}

foreach ($app in $frontendApps) {
    cd $app\src\main\frontend;
    npm run build;
    cd ..\..\..\..;
}