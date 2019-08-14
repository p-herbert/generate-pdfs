import _ from 'underscore';

export function checkPostRequest(req, res, next) {
    const { body } = req;

    if (_.isEmpty(body)) {
        return res.status(400).send({ error: 'Missing body' });
    }

    next();
}
