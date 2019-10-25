import { Sequelize } from 'sequelize';
require('dotenv').config();

const databaseConfig = {
    "username": "",
    "password": "",
    "database": "stockmkt",
    "host": "localhost",
    "port": "5445",
    "dialect": "postgres"
}
console.log({ databaseConfig });

const db = databaseConfig;
const connection = new Sequelize({
    username: db.username,
    port: db.port,
    password: db.password,
    database: db.database,
    host: db.host,
    dialect: db.dialect,
    // dialectOptions: { decimalNumbers: true }

});

console.info('SETUP -- CONNECTTION TO DATABASE...');
connection
    .authenticate()
    .then(() => {
        console.info("=====DATABASE CONNECTED======")
    })
    .catch((err) => {
        console.error("======UNABLE TO CONNECT TO DATABASE=======", err)
    });

export default connection; 