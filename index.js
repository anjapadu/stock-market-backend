
import express from 'express';
import cors from 'cors';
import bodyParser from 'body-parser';
import morgan from 'morgan';
import http from 'http';
import graphRouter from './src/routes/graph'
import moment from 'moment'
import middleware from './src/lib/security-middleware'
import path from 'path'
import { io } from './src/lib/socket';
const gzipStatic = require('connect-gzip-static');
import models from '@models'
const fs = require('fs')
var cron = require('node-cron');


let lastEmail = null

// import publicRouter from './src/routes/public';
// import privateRouter from './src/routes/private';

const app = express();
let mw = middleware({
    credentialsRequired: false
})
app.use('/graph', mw);
app.disable('x-powered-by');

app.use(bodyParser.urlencoded({
    extended: true
}));
app.use(bodyParser.json());
app.use(morgan(':method :url :status :res[content-length] - :response-time ms'));
var corsOptions = {
    origin: function (origin, callback) {
        return callback(null, true)
        if (allowedOrigins[origin]) {
            return callback(null, true)
        } else {
            callback(new Error('ERR_CORS'))
        }
    }
};

app.use(cors(corsOptions));
app.use('/', graphRouter);

/**
 * Error formatter/handler
 */
app.use(function (err, req, res, next) {
    if (err) {
        switch (err.message) {
            case 'AUTHORIZATION_ERROR':
                return res.status(401).json({
                    code: 403,
                    message: 'Authorization error'
                })
            case 'ERR_CORS':
                return res.status(403).json({
                    code: 403,
                    message: 'Not allowed by CORS'
                });
            default:
                return res.status(err.status || 500).json({
                    code: err.status || 500,
                    message: err.message.charAt(0).toUpperCase() + err.message.slice(1)
                });
        }
    }
    return next()
})

io.use(function (socket, next) {
    var handshakeData = socket.request;
    const { user_uuid } = handshakeData._query
    if (user_uuid) {
        socket.join(`user_${handshakeData._query.user_uuid}`)
    }
    next();
});

io.on('connection', function (socket) {
    console.log('CONNECTED USER');
});

const httpServer = http.createServer(app);
httpServer.listen(5010, () => {
    console.log('HTTP Server running on 5010')
    cron.schedule('* * * * *', () => {
        console.log('running a task every minute');
        io.emit('new.stock.value', {
            "uuid": "79d7cce6-c2db-4f17-9df0-f1f624c3e96d",
            "stock_uuid": "e44f0c5d-47b8-42f5-b44b-17208bc89929",
            "close_price": 250.6,
            "timestamp": "06/10/2019 12:02",
            "change_price": -6.83,
            "change_percent": -2.653
        })
    });
})