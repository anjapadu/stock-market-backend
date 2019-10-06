
import uuid from 'uuid/v4'

export default (sequelize, DataTypes) => {
  const transactions = sequelize.define('transactions', {
    uuid: {
      type: DataTypes.UUID,
      primaryKey: true,
      field: 'uuid',
    },
    status: {
      type: DataTypes.STRING
    },
    stock_uuid: {
      type: DataTypes.UUID
    },
    stock_price_uuid: {
      type: DataTypes.UUID
    },
    user_uuid: {
      type: DataTypes.UUID
    },
    created_at: {
      type: DataTypes.STRING
    },
    updated_at: {
      type: DataTypes.STRING
    },
    is_sell: {
      type: DataTypes.BOOLEAN
    },
    is_buy: {
      type: DataTypes.BOOLEAN
    },
    comission: {
      type: DataTypes.DECIMAL
    },
    quantity: {
      type: DataTypes.INTEGER
    },
    comission_rate: {
      type: DataTypes.DECIMAL
    },
    total: {
      type: DataTypes.DECIMAL
    },

  }, {
    tableName: 'transactions',
    timestamps: false
  })

  transactions["associate"] = (models) => {
    models.transactions.belongsTo(models.stocks, {
      foreignKey: 'stock_uuid'
    })
    models.transactions.belongsTo(models.stock_price, {
      foreignKey: 'stock_price_uuid'
    })

    models.transactions.belongsTo(models.users, {
      foreignKey: 'user_uuid'
    })
  }
  transactions.beforeCreate((transaction, _) => {
    return transaction.uuid = uuid();
  });
  return transactions;
}