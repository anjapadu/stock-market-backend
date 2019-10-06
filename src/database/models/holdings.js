import uuid from 'uuid/v4'

export default (sequelize, DataTypes) => {
  const holdings = sequelize.define('holdings', {
    stock_uuid: {
      type: DataTypes.UUID,
      primaryKey: true,

    },
    user_uuid: {
      type: DataTypes.UUID,
      primaryKey: true,

    },
    quantity: {
      type: DataTypes.INTEGER
    }
  }, {
    tableName: 'holdings',
    timestamps: false
  })
  holdings["associate"] = (models) => {
    models.holdings.belongsTo(models.users, {
      foreignKey: 'user_uuid'
    })
    models.holdings.belongsTo(models.stocks, {
      foreignKey: 'stock_uuid'
    })
  }
  return holdings;
}
