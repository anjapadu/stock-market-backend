import uuid from 'uuid/v4'

export default (sequelize, DataTypes) => {
  const users = sequelize.define('users', {
    uuid: {
      type: DataTypes.UUID,
      primaryKey: true,
      field: 'uuid'
    },
    username: {
      type: DataTypes.STRING
    },
    password: {
      type: DataTypes.STRING
    },
    admin: {
      type: DataTypes.BOOLEAN
    },
    balance: {
      type: DataTypes.DECIMAL
    }
  }, {
    tableName: 'users',
    timestamps: false
  })
  users.beforeCreate((user, _) => {
    return user.uuid = uuid();
  });
  users["associate"] = (models) => {

  }
  return users;
}