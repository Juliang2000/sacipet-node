

const imageToBase64 = require('image-to-base64');

imageToBase64("./src/uploads/158.jpg") // insert image url here. 
    .then( (response) => {
          console.log(response);  // the response will be the string base64.
      }
    )
    .catch(
        (error) => {
            console.log(error);
        }
    )