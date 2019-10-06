import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLInt,
    GraphQLList,
    GraphQLBoolean,
    GraphQLFloat
} from 'graphql';
import DateGenerator from '../_customTypes/DateGenerator'
import StockType from '../stocks/typeDef'
import StockPriceType from '../stock_price/typeDef'
import { fetchStockPriceById } from '../stock_price/resolvers';
import { fetchStock } from '../stocks/resolvers';

export default new GraphQLObjectType({
    name: 'transactions',
    description: 'transactions',
    fields: function () {
        return {
            uuid: {
                type: GraphQLString,
                description: 'UUID of the user'
            },
            status: {
                type: GraphQLString,
                description: 'Username of the user'
            },
            stock_uuid: {
                type: GraphQLString,
                description: 'User flag admin'
            },
            stock_price_uuid: {
                type: GraphQLString
            },
            user_uuid: {
                type: GraphQLString
            },
            created_at: DateGenerator('created_at'),
            updated_at: DateGenerator('created_at'),
            is_buy: {
                type: GraphQLBoolean
            },
            is_sell: {
                type: GraphQLBoolean
            },
            stock_price: {
                type: StockPriceType,
                resolve: fetchStockPriceById
            },
            stock: {
                type: StockType,
                resolve: fetchStock
            },
            comission: {
                type: GraphQLFloat,
            },
            quantity: {
                type: GraphQLInt
            },
            comission_rate: {
                type: GraphQLFloat
            },
            total: {
                type: GraphQLFloat
            }
        }
    }
});