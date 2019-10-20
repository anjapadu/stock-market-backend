import uuid from 'uuid/v4'

export default (sequelize, DataTypes) => {
  const stocks = sequelize.define('stocks', {
    uuid: {
      type: DataTypes.UUID,
      primaryKey: true,
      field: 'uuid',
      defaultValue: uuid()
    },
    name: {
      type: DataTypes.STRING
    },
    description: {
      type: DataTypes.STRING
    },
    companyname: {
      type: DataTypes.STRING
    },
    quantity: {
      type: DataTypes.INTEGER
    },
    currency: {
      type: DataTypes.STRING
    },
    companylogo: {
      type: DataTypes.STRING
    }

  }, {
    tableName: 'stocks',
    timestamps: false
  })
  stocks["associate"] = (models) => {
    models.stocks.hasMany(models.stock_price, {
      foreignKey: 'uuid'
    })
    models.stocks.hasMany(models.future_values, {
      foreignKey: 'uuid'
    })
  }
  stocks.beforeCreate((stock, _) => {
    return stock.uuid = uuid();
  });
  return stocks;
}
