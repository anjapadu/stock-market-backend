import models from '@models'
import { io } from '../../../../lib/socket'

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