const puppeteer = require('puppeteer');

const puppeteerApi = {
    pdf: async ({
        html,
        margin = {
            top: '0px',
            left: '0px',
            bottom: '0px',
            right: '0px',
        },
        // A4 page at 96 PPI
        width = '794px',
        height = '1123px',
    }) => {
        try {
            // Create new browser
            const browser = await puppeteer.launch({
                args: [
                    '--no-sandbox',
                    '--disable-gpu',
                    '--headless',
                    '--disable-setuid-sandbox',
                ],
            });

            // Create new page
            const page = await browser.newPage();

            // Load html
            await page.setContent(html, {
                waitUntil: ['load', 'domcontentloaded', 'networkidle0'],
            });

            // Generate pdf
            const pdf = await page.pdf({
                displayHeaderFooter: false,
                printBackground: true,
                width,
                height,
                margin,
            });

            // Close the page
            await page.close();

            // Close the browser
            await browser.close();

            return Promise.resolve(pdf);
        } catch (error) {
            console.log(error);

            return Promise.reject(error);
        }
    },
};

export default puppeteerApi;
