$directories = @(
    "01-ssr",
    "02-ssr-with-progressive-enhancement",
    "03-ssr-with-partial-dom-updates",
    "04-ssr-with-partial-csr",
    "05-csr-with-spa",
    "06-ssr-with-rehydration"
)

rm .\reports\*.json
rm .\reports\*.html

for ($i = 1; $i -le 6; $i++) {
    $reportName = $directories[$i - 1];
    lighthouse "https://todo-app-$i.holisticon.de/" --output-path "./reports/$reportName.html" --save-assets --view
}