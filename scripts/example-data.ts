import { chromium } from 'playwright';

(async () => {
    for (let i = 1; i <= 6; i++) {
        const app = `todo-app-${i}`;
        const browser = await chromium.launch();
        const context = await browser.newContext({ locale: 'en-US', viewport: { width: 800, height: 470 } });
        const page = await context.newPage();
        page.goto(`https://${app}.holisticon.de/`);

        await page.waitForLoadState('networkidle');

        // await page.fill('#addTask-description', 'Seacon-Vortrag vorbereiten 👨🏻‍🏫');
        // await page.fill('#addTask-dueDate', '2021-04-22');
        // await page.click('button.add-task');

        // await page.waitForTimeout(1000);

        // await page.fill('#addTask-description', 'Space Jam gucken 🏀');
        // await page.click('button.add-task');

        // await page.waitForTimeout(1000);

        // await page.fill('#addTask-description', 'VM mit Windows 95 und FrontPage 1.1 aufsetzen 👨🏻‍💻');
        // await page.click('button.add-task');

        // await page.waitForTimeout(1000);

        await page.screenshot({ path: `${app}.png` });
        context.close();
        await browser.close();
    }
})();