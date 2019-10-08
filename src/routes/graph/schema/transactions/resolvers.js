import models from '@models';
import { io } from '../../../../lib/socket';


export async function fetchTransactions(_parent, { user_uuid }) {
    return await models.transactions.findAll({
        where: {
            user_uuid
        }
    })
}

async function checkIfTransactionIsValid(user_uuid, total, quantity, is_buy, stock_uuid, price) {
    const response = await models.users.findOne({
        where: {
            uuid: user_uuid,
        },
        raw: true
    })
    const userBalance = response["balance"]
    if (is_buy) {
        if (userBalance >= total) {
            return userBalance;
        } else {
            throw new Error('NOT_ENOUGHT_FUNDS')
        }
    } else {
        const totalStocksOwned = (await models.holdings.findOne({
            where: {
                user_uuid,
                stock_uuid
            }
        }))['quantity']
        if (total >= 1500 && totalStocksOwned >= quantity) {
            return userBalance
        } else if (total < 1500 && (totalStocksOwned * price) < 1500) {
            return userBalance
        } else {
            throw new Error('NOT_VALID_SELL')
        }
    }

}

async function updateBalance(is_buy, total, balance, user_uuid) {

    models.users.update({
        balance: (balance + (is_buy ? (-1 * total) : total))
    }, {
        where: {
            uuid: user_uuid
        }
    })
    if (io.sockets.adapter.rooms[`user-${user_uuid}`]) {
        io.to(`user-${user_uuid}`).emit('new.balance', (balance + (is_buy ? (-1 * total) : total)))
    }
}

async function createOrChangeHoldings(stock_uuid, user_uuid, quantity, is_buy) {
    const holding = await models.holdings.findOne({
        where: {
            user_uuid,
            stock_uuid
        },
        raw: true
    })
    if (!holding) {
        await models.holdings.create({
            stock_uuid,
            user_uuid,
            quantity
        }).then((result) => result.get({ plan: true }))

        if (io.sockets.adapter.rooms[`user-${user_uuid}`]) {
            io.to(`user-${user_uuid}`).emit('upsert.holding', {
                stock_uuid,
                quantity
            })
        }

    } else {
        const newQuantity = holding['quantity'] + (is_buy ? quantity : -quantity)
        await models.holdings.update({
            quantity: newQuantity
        }, {
            where: {
                stock_uuid,
                user_uuid
            },
            raw: true
        })
        if (newQuantity == 0) {
            await models.holdings.destroy({
                where: {
                    stock_uuid,
                    user_uuid
                }
            })
        }
        if (io.sockets.adapter.rooms[`user-${user_uuid}`]) {
            io.to(`user-${user_uuid}`).emit('upsert.holding', {
                stock_uuid,
                quantity: holding['quantity'] + (is_buy ? quantity : -quantity)
            })
        }
    }

}

export async function createTransaction(_parent, { user_uuid, stock_uuid, stock_price_uuid, is_buy, quantity }) {
    const lastPrice = await models.stock_price.findOne({
        where: {
            stock_uuid: stock_uuid,
        },
        order: [['timestamp', 'DESC']],
        raw: true
    })
    const lastPriceUUID = lastPrice['uuid']
    const price = lastPrice['close_price']

    const stocksValue = quantity * price
    if (lastPriceUUID === stock_price_uuid) {
        const total = parseFloat(is_buy ? ((0.008 * stocksValue) + stocksValue).toFixed(2) : (stocksValue - (0.008 * stocksValue)).toFixed(2))
        const balance = await checkIfTransactionIsValid(user_uuid, total, quantity, is_buy, stock_uuid, price)
        console.log({ balance })
        const transaction = await models.transactions.create({
            stock_uuid,
            status: 'COMPLETED',
            stock_price_uuid,
            user_uuid,
            is_buy,
            is_sell: !is_buy,
            comission: (0.008 * stocksValue).toFixed(2),
            comission_rate: 0.008,
            total,
            quantity
        })
            .then((result) => result.get({ plain: true }))
        updateBalance(is_buy, total, balance, user_uuid)
        createOrChangeHoldings(stock_uuid, user_uuid, quantity, is_buy)

        return transaction
    }
}