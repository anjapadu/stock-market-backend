export default (sequelize, DataTypes) => {
  const future_values = sequelize.define('future_values', {
    uuid: {
      type: DataTypes.UUID,
      primaryKey: true,
      field: 'uuid'
    },
    stock_uuid: {
      type: DataTypes.UUID
    },
    timestamp: {
      type: DataTypes.STRING
    },
    new_price: {
      type: DataTypes.DECIMAL
    },
    has_new: {
      type: DataTypes.BOOLEAN
    },
    new_text: {
      type: DataTypes.STRING
    },
    delay: {
      type: DataTypes.INTEGER
    },
    sent: {
      type: DataTypes.BOOLEAN
    }

  }, {
    tableName: 'future_values',
    timestamps: false
  })
  future_values["associate"] = (models) => {
    models.future_values.belongsTo(models.stocks, {
      foreignKey: 'stock_uuid'
    })
  }
  future_values.beforeCreate((future_value, _) => {
    return future_value.uuid = uuid();
  });
  return future_values;
}