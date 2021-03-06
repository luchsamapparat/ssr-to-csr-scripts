$backendApps = @(
    "01-ssr",
    "02-ssr-with-progressive-enhancement",
    "03-ssr-with-partial-dom-updates",
    "04-ssr-with-partial-csr",
    "05-csr-with-spa",
    "06-ssr-with-rehydration"
)

foreach ($app in $backendApps) {
    cd $app;
    ./mvnw clean install -DskipTests;
    cd..;
}