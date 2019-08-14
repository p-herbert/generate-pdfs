import { puppeteerApi } from '../../../api';

const pdfController = {
    async post({ req, res }) {
        try {
            const {
                body: { html, margin, width, height },
            } = req;

            // Generate pdf
            const pdf = await puppeteerApi.pdf({ html, margin, width, height });

            console.log('Success! Generated PDF!');

            return res
                .status(200)
                .type('application/pdf')
                .send(pdf);
        } catch (error) {
            console.log(error);

            return res.send({ error });
        }
    },
};

export default pdfController;
