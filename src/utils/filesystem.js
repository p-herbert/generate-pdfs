const fs = require('fs');

export function read(filename) {
    return new Promise((resolve, reject) => {
        fs.readFile(filename, 'utf-8', (error, data) => {
            if (error) {
                return reject(error);
            }

            resolve(data);
        });
    });
}

export function write(filename, data) {
    return new Promise((resolve, reject) => {
        fs.writeFile(filename, data, { encoding: 'utf-8' }, error => {
            if (error) {
                return reject(error);
            }

            resolve(filename);
        });
    });
}

export function del(filename) {
    return new Promise((resolve, reject) => {
        fs.unlink(filename, error => {
            if (error) {
                return reject(error);
            }

            resolve(filename);
        });
    });
}
