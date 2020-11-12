const http = require('http')
const fs = require('fs')
const url = require("url");
var path = require("path");
var { parse } = require('querystring');

mimeTypes = {
    "html": "text/html",
    "jpeg": "image/jpeg",
    "jpg": "image/jpeg",
    "png": "image/png",
    "js": "text/javascript",
    "css": "text/css"
};

http.createServer((req, res) => {
    var requrl = url.parse(req.url, true);
    var uri = requrl.pathname;
    var filename = path.join(process.cwd(), uri);

    if (uri === '/favicon.ico') {
        ignoreFavicon(uri, response);
        return;
    }
    if (fs.statSync(filename).isDirectory())
        filename += 'web/index.html';

    readfile(res, filename);
}).listen(8080)

function readfile(response, filename) {
    fs.readFile(filename, "binary", function(err, file) {
        handleError(response, err);
        var mimeType = mimeTypes[filename.split('.').pop()];

        if (!mimeType) {
            mimeType = 'text/plain';
        }
        response.writeHead(200, { "Content-Type": mimeType });
        response.write(file, "binary");
        response.end();
    });
}



function ignoreFavicon(uri, response) {
    response.writeHead(200, { 'Content-Type': 'image/x-icon' });
    response.end();
}

function handleNonExist(response, exists) {
    if (!exists) {
        response.writeHead(404, { "Content-Type": "text/plain" });
        response.write("404 Not Found\n");
        response.end();
        return;
    }
}

function handleError(response, err) {
    if (err) {
        response.writeHead(500, { "Content-Type": "text/plain" });
        response.write(err + "\n");
        response.end();
        return;
    }
}