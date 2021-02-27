$directories = @(
    "02-ssr-with-progressive-enhancement",
    "03-ssr-with-partial-dom-updates",
    "04-ssr-with-partial-csr",
    "05-csr-with-spa",
    "06-ssr-with-rehydration"
)

foreach ($directory in $directories) {
    cd $directory;
    git pull;
    git merge origin/01-ssr;
    git push;
    cd..;
}
