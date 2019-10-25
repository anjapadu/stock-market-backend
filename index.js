
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
import uuid from 'uuid/v4'

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


async function fetchAndUpdateFutureValues(isShot = false) {
    const futureValues = await models.future_values.findAll({
        where: {
            sent: false,
            timestamp: models.Sequelize.literal('future_values.timestamp = (SELECT MIN(timestamp) FROM future_values as fv WHERE fv.stock_uuid = future_values.stock_uuid AND fv.sent is not true)')
        },
        order: [
            ['timestamp', 'ASC']
        ],
        raw: true
    })
    if (!futureValues || futureValues.length === 0) {
        return;
    }
    const lastPricesByStock = (await models.stock_price.findAll({
        where: {
            timestamp: models.Sequelize.literal('timestamp = (SELECT MAX(timestamp) FROM stock_price as sp WHERE sp.stock_uuid = stock_price.stock_uuid)')
        },
        raw: true
    })).reduce((prev, curr) => {
        prev[curr.stock_uuid] = curr
        return prev
    }, {})

    const newValuesToEnter = futureValues.map((newValue) => {
        const lastPrice = lastPricesByStock[newValue.stock_uuid]['close_price']
        const changePercent = 100 - ((lastPrice / (newValue['new_price'])) * 100)
        const changePrice = newValue['new_price'] - lastPrice
        return {
            uuid: uuid(),
            hasNew: newValue.has_new,
            newText: newValue.new_text,
            stock_uuid: newValue.stock_uuid,
            close_price: newValue['new_price'].toFixed(2),
            timestamp: moment().format('YYYY-MM-DD HH:mm:ss'),
            change_price: changePrice.toFixed(2),
            change_percent: changePercent.toFixed(2)
        }
    })

    const valuesWithNews = newValuesToEnter.filter((item) => item.hasNew)
    const news = valuesWithNews.map((item) => ({
        stockUUID: item.stock_uuid,
        new: item.newText
    }))
    io.emit('new.new', {
        news,
        time: moment().format('DD/MM/YYYY_HH:mm:ss')
    })
    setTimeout(async () => {
        const newPricesToSendLater = await models.stock_price.bulkCreate(valuesWithNews, { returning: true })
        const newPricesUUIDs = newPricesToSendLater.reduce((prev, curr) => {
            prev[curr['stock_uuid']] = curr.uuid
            return prev
        }, {})
        const idsToUpdateLater = valuesWithNews.map((item) => item.stock_uuid)
        await models.future_values.update({
            sent: true
        }, {
            where: {
                timestamp: models.Sequelize.literal('future_values.timestamp = (SELECT MIN(timestamp) FROM future_values as fv WHERE fv.stock_uuid = future_values.stock_uuid AND sent IS NOT true)'),
                stock_uuid: {
                    [models.Sequelize.Op.in]: idsToUpdateLater
                }
            }
        })
        const values = valuesWithNews.reduce((prev, curr) => {
            prev[curr["stock_uuid"]] = {
                ...curr,
                priceUUID: newPricesUUIDs[curr["stock_uuid"]]
            }
            return prev
        }, {})
        io.emit('new.stock.values', {
            values
        })
    }, (isShot ? 500 : 120000))

    const valuesWithoutNew = newValuesToEnter.filter((item) => !item.hasNew)
    const newPricesToSendNow = await models.stock_price.bulkCreate(valuesWithoutNew, { returning: true })
    const idsToUpdateNow = valuesWithoutNew.map((item) => item.stock_uuid)

    const newPricesUUIDs = newPricesToSendNow.reduce((prev, curr) => {
        prev[curr['stock_uuid']] = curr.uuid
        return prev
    }, {})
    await models.future_values.update({
        sent: true
    }, {
        where: {
            timestamp: models.Sequelize.literal('future_values.timestamp = (SELECT MIN(timestamp) FROM future_values as fv WHERE fv.stock_uuid = future_values.stock_uuid AND sent IS NOT true)'),
            stock_uuid: {
                [models.Sequelize.Op.in]: idsToUpdateNow
            }
        }
    })
    const values = valuesWithoutNew.reduce((prev, curr) => {
        prev[curr["stock_uuid"]] = {
            ...curr,
            priceUUID: newPricesUUIDs[curr["stock_uuid"]]
        }
        return prev
    }, {})
    io.emit('new.stock.values', {
        values
    })
}


app.get('/shot', (req, res) => {
    fetchAndUpdateFutureValues(true)
    res.status(200).send({
        success: true
    })
})

const httpServer = http.createServer(app);
httpServer.listen(5015, () => {
    console.log('HTTP Server running on 5010')
    cron.schedule('*/3 * * * *', async () => {
        console.log('Sending New Value');
        if (global.status === 'STARTED')
            fetchAndUpdateFutureValues()
    });
})