$directories = @(
    "01-ssr",
    "02-ssr-with-progressive-enhancement",
    "03-ssr-with-partial-dom-updates",
    "04-ssr-with-partial-csr",
    "05-csr-with-spa",
    "06-ssr-with-rehydration"
)

foreach ($directory in $directories) {
    git clone https://github.com/luchsamapparat/ssr-to-csr.git $directory
    cd $directory
    git checkout $directory
    cd ..
}