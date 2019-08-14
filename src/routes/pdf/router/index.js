import pdfController from '../controller';
import { checkPostRequest } from '../../../utils';

const pdfRouter = require('express').Router();

pdfRouter.route('/').post(checkPostRequest, (req, res) =>
    pdfController.post({
        req,
        res,
    })
);

export default pdfRouter;
