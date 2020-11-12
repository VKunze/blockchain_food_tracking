const http = require('http')
const fs = require('fs')

const server = http.createServer((req, res) => {
    console.log("starting")
    res.writeHead(200, { 'content-type': 'text/html' })
    fs.createReadStream('web/index.html').pipe(res)
    console.log("created server")
})

server.listen(8080)