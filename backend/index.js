const express = require("express");
const path = require("path");

const port = process.env.PORT || 5000;
const app = express();

app.use(express.json());

app.get('/test', (req, res) => {
    res.json({'testVal' : 'test'})
});

app.use(require(path.resolve(__dirname, "./Routers/Router")));

app.listen(port, () => console.log(`Example app listening on port ${port}!`));