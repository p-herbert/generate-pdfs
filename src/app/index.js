import { pdfRouter } from '../routes';

const express = require('express');
const bodyParser = require('body-parser');
const compression = require('compression');

// Create the Express application
const app = express();

// Add body-parser
app.use(bodyParser.urlencoded({ limit: '15mb', extended: true }));
app.use(bodyParser.json({ limit: '15mb' }));

// Add compression
app.use(compression({ filter: shouldCompress }));

// Add routers
app.use('/pdf', pdfRouter);

function shouldCompress(req, res) {
    if (req.headers['x-no-compression']) {
        return false;
    }

    return compression.filter(req, res);
}

export default app;
