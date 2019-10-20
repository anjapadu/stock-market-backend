export default (sequelize, DataTypes) => {
  const params = sequelize.define('params', {
    uuid: {
      type: DataTypes.UUID,
      primaryKey: true,
      field: 'uuid'
    },
    name: {
      type: DataTypes.STRING
    },
    type: {
      type: DataTypes.STRING
    },
    value: {
      type: DataTypes.STRING
    }

  }, {
    tableName: 'params',
    timestamps: false
  })
  params["associate"] = (models) => {

  }
  params.beforeCreate((param, _) => {
    return param.uuid = uuid();
  });
  return params;
}