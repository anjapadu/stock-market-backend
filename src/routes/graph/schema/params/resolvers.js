import models from '@models'
import { io } from '../../../../lib/socket'


export const resetGame = async () => {
  await models.sequelize.query(`TRUNCATE TABLE transactions,holdings,stock_price;
  INSERT INTO stock_price (stock_uuid, close_price, "timestamp", change_price, change_percent)
  SELECT 
  stock_uuid, 	
  (SELECT new_price FROM future_values WHERE stock_uuid = tmp.stock_uuid ORDER BY timestamp ASC LIMIT 1) AS stock_price,
  (SELECT timestamp from future_values WHERE stock_uuid = tmp.stock_uuid ORDER BY "timestamp" ASC LIMIT 1) AS timestamp,
   0.0 AS change_price,
   0.0 as change_percent
   FROM 
  (SELECT 
    stock_uuid
  FROM future_values GROUP by stock_uuid ) as tmp;
  update future_values SET sent = false;
  `,)
  return { success: true }
}
export const updateComission = async (_, { comission }) => {
  await models.params.update({
    value: comission
  }, {
    where: {
      name: 'comission'
    }
  })
  io.emit('param.change', {
    name: 'comission',
    value: comission
  })
  global.comission = comission;
  return {
    success: true
  }
}

export const updateExchangeRate = async (_, { exchangeRate }) => {
  await models.params.update({
    value: exchangeRate
  }, {
    where: {
      name: 'exchange_rate'
    }
  })
  io.emit('param.change', {
    name: 'exchangeRate',
    value: exchangeRate
  })
  global.exchangeRate = exchangeRate;
  return {
    success: true
  }
}

export const updateStatus = async (_, { status }) => {
  await models.params.update({
    value: status
  }, {
    where: {
      name: 'status'
    }
  })
  io.emit('param.change', {
    name: 'status',
    value: status
  })
  global.status = status;
  return {
    success: true
  }
}