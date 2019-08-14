import app from './app';

// Load configurations
const config = require('config');
const { port, host } = config;

app.listen(port, host, () =>
    console.log(`App server starting on host ${host} and port ${port}...`)
);
