
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

global.comission = null;
global.status = null;
global.exchangeRate = null;
global.ids = null;

(async function loadParameters() {
    const data = await models.params.findAll({
        raw: true
    })
    data.forEach((param) => {
        switch (param["name"]) {
            case 'comission':
                global.comission = parseFloat(param.value)
                break;

            case 'exchange_rate':
                global.exchangeRate = parseFloat(param.value)
                break;
            default:
                global.status = param.value
        }
    })
})();

(async function fetchStocksIds() {
    const stocksIds = await models.stocks.findAll({
        raw: true
    })
    const result = stocksIds.reduce((prev, curr) => {
        prev[curr['uuid']] = true
        return prev
    }, {})
    global.ids = result
})();
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
    const { userUUID } = handshakeData._query
    if (userUUID) {
        console.log('CONECTO A USER SOCKET')
        socket.join(`user-${userUUID}`)
    }
    next();
});

io.on('connection', function (socket) {
    console.log('CONNECTED USER');
});
// async function fetchRandom() {

//     const response = (await models.sequelize.query("SELECT * FROM stock_price ORDER BY RANDOM() LIMIT 1", {
//         type: models.Sequelize.QueryTypes.SELECT
//     }))[0]
//     let toSum = parseFloat(((Math.random() * 5) + 1))
//     toSum *= Math.floor(Math.random() * 2) == 1 ? 1 : -1;
// const changePercent = 100 - ((parseFloat(response["close_price"]) / (toSum + parseFloat(response["close_price"]))) * 100)
//     response["close_price"] = parseFloat((parseFloat(response["close_price"]) + toSum).toFixed(3))
//     response["change_price"] = parseFloat(toSum.toFixed(3))
//     response["change_percent"] = parseFloat(changePercent.toFixed(3))
//     response["timestamp"] = moment().format('DD/MM/YYYY HH:mm')
//     return response
//     // 100 - 250.6
//     // %     230.6
// }


var randomObjectKey = function (obj) {
    var keys = Object.keys(obj)
    return keys[keys.length * Math.random() << 0];
};



// const ids = fetchStocksIds()
// const stockIds =
async function fetchAndUpdateFutureValue(stock_uuid = randomObjectKey(global.ids)) {
    const result = await models.future_values.findOne({
        where: {
            sent: false,
            stock_uuid: stock_uuid
        },
        order: [
            ['timestamp', 'ASC']
        ],
        raw: true
    })
    if (!result) {
        fetchAndUpdateFutureValue()
    }
    if (result.has_new) {
        io.emit('show.new', {
            new: result.new_text
        })
    }

    const lastPrice = await models.stock_price.findOne({
        where: {
            stock_uuid,
        },
        order: [['timestamp', 'DESC']]
    })
    const changePercent = 100 - ((parseFloat(lastPrice['close_price']) / (result['new_price'])) * 100)
    const changePrice = parseFloat(result['new_price']) - parseFloat(lastPrice['close_price'])

    const newStockPrice = await models.stock_price.create({
        stock_uuid,
        close_price: parseFloat(result['new_price']).toFixed(2),
        timestamp: moment(result['timestamp']).format('YYYY-MM-DD HH:mm'),
        change_price: parseFloat(changePrice).toFixed(2),
        change_percent: parseFloat(changePercent).toFixed(2)
    }).then((result) => result.get({ plain: true }))

    io.emit('new.stock.value', {
        ...newStockPrice,
        timestamp: moment(newStockPrice.timestamp).format('DD/MM/YYYY @ HH:mm')
    })

    await models.future_values.update({
        sent: true
    }, {
        where: {
            uuid: result['uuid']
        }
    })
}

setInterval(async () => {
    // console.log('GLOBAL.IDS', global.ids)
    // console.log('randomObjectKey(global.ids)', randomObjectKey(global.ids))
    // await fetchAndUpdateFutureValue()
    // io.emit('new.stock.value', data)
}, 5000)

const httpServer = http.createServer(app);
httpServer.listen(5015, () => {
    console.log('HTTP Server running on 5010')
    cron.schedule('* * * * *', async () => {
        console.log('Sending New Value');
        // const data = await fetchRandom()
        // io.emit('new.stock.value', data)
        // if (global.status === 'STARTED')
        //     await fetchAndUpdateFutureValue()
    });
})