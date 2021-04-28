import { launch } from 'chrome-launcher';
import { mkdir, writeFile } from 'fs/promises';
import * as lighthouse from 'lighthouse';

(async () => {
    const i = 5;
    const app = `todo-app-${i}`;
    const dir = `${app}-${(Date.now() / 1000)}`;
    mkdir(dir);

    const chrome = await launch({ chromeFlags: ['--headless', '--window-size=1350,940'] });
    const options = {
        port: chrome.port,
        formFactor: 'desktop',
        screenEmulation: {
            disabled: true,
        },
        emulatedUserAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4420.0 Safari/537.36 Chrome-Lighthouse'
    };
    const result = await lighthouse(`https://${app}.holisticon.de/`, options);

    await Promise.all(
        result.lhr.audits['screenshot-thumbnails'].details.items
            .map(async ({ timing, data }) => {
                const screenshot = data.split(';base64,').pop();
                const screenshotFile = `screenshot-${timing}ms.jpg`;
                return writeFile(`${dir}/${screenshotFile}`, screenshot, { encoding: 'base64' });
            })
    );

    const finalScreenshotFile = `${dir}/screenshot-final.jpg`;
    const finalScreenshot = result.lhr.audits['final-screenshot'].details.data.split(';base64,').pop();
    await writeFile(finalScreenshotFile, finalScreenshot, { encoding: 'base64' });

    await chrome.kill();
})();








// import { chromium } from 'playwright';

// (async () => {
//         for (let i = 1; i <= 6; i++) {
//             const app = `todo-app-${i}`;
//         const browser = await chromium.launch();
//         const context = await browser.newContext({ recordVideo: { dir: __dirname } });
//         const page = await context.newPage();
//         page.goto(`https://${app}.holisticon.de/`);

//         await page.waitForLoadState('networkidle');

//         const videoPath = await page.video().path();

//         await context.close();
//         await browser.close();

//         console.log(`${app}: ${videoPath}`);
//     }
// })();


// import { mkdir, readFile, writeFile } from 'fs/promises';
// import { chromium } from 'playwright';

// (async () => {
//     const i = 1;
//     const app = `todo-app-${i}`;
//     const dir = `${app}-${(Date.now() / 1000)}`;
//     await mkdir(dir);
//     const browser = await chromium.launch();
//     const page = await browser.newPage();

//     await browser.startTracing(page, { screenshots: true, path: `${dir}/trace.json` });
//     await page.goto(`https://${app}.holisticon.de/`, { timeout: 60000 });

//     await page.waitForLoadState('networkidle');

//     await browser.stopTracing();

//     // Extract data from the trace
//     const tracing = JSON.parse(await readFile(`./${dir}/trace.json`, 'utf8'));
//     const traceScreenshots = tracing.traceEvents.filter(event => (
//         event.cat === 'disabled-by-default-devtools.screenshot' &&
//         event.name === 'Screenshot' &&
//         typeof event.args !== 'undefined' &&
//         typeof event.args.snapshot !== 'undefined'
//     ));

//     Promise.all(
//         traceScreenshots.map((snap, index) => {
//             return writeFile(`${dir}/trace-screenshot-${index}.png`, snap.args.snapshot, 'base64');
//         })
//     );

//     await browser.close();
// })();




// import { mkdir, readFile, writeFile } from 'fs/promises';
// import { chromium } from 'playwright';
// import * as speedline from 'speedline-core';

// (async () => {
//     for (let i = 1; i <= 6; i++) {
//         const app = `todo-app-${i}`;
//         // const dir = `${app}-${(Date.now() / 1000)}`;
//         const dir = app;
//         await mkdir(dir);
//         const tracePath = `./${dir}/trace.json`;
//         const browser = await chromium.launch();
//         const page = await browser.newPage();

//         await browser.startTracing(page, { screenshots: true, path: tracePath });
//         await page.goto(`https://${app}.holisticon.de/`, { timeout: 60000 });

//         await page.waitForLoadState('networkidle');

//         await browser.stopTracing();
//         await browser.close();

//         const tracing = JSON.parse(await readFile(`./${dir}/trace.json`, 'utf8'));

//         const { frames, beginning, first } = await speedline(tracing.traceEvents, {
//             fastMode: false
//         });

//         await Promise.all(
//             frames.map(frame => {
//                 const timestamp = Math.round(frame.getTimeStamp() - beginning);
//                 return writeFile(`${dir}/trace-screenshot-${timestamp}.jpg`, frame.getImage(), 'base64');
//             })
//         );
//     }
// })();