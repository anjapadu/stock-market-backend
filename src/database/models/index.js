import Sequelize from 'sequelize'
import databaseConnection from '../connection'
import users from './users'
import stocks from './stocks'
import stock_price from './stock_price'
import transactions from './transactions'
import holdings from './holdings'

const models = {
  users: databaseConnection.import("users", users),
  stocks: databaseConnection.import("stocks", stocks),
  stock_price: databaseConnection.import("stock_price", stock_price),
  holdings: databaseConnection.import("holdings", holdings),
  transactions: databaseConnection.import("transactions", transactions),
}

Object.keys(models).forEach((modelName) => {
  if ('associate' in models[modelName]) {
    models[modelName].associate(models)
  }
})

models.sequelize = databaseConnection;
models.Sequelize = Sequelize;

export default models;