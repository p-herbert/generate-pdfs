# Generate-PDFs

Service for generating PDFs.

### Routes

- **PDF**
	- `POST /pdf`
        - `body` **Object**
        - `html` **String**
        - `margin` **Object**
            - `top` **String**
            - `left` **String**
            - `bottom` **String**
            - `right` **String**
        - `height` **String**
        - `width` **String**

### Running the service locally

The server can be run locally with the command:

~~~
npm run dev
~~~

It will start on `http://localhost:8080`.
