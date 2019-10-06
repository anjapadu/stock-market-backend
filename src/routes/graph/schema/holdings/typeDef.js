import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLInt,
    GraphQLList,
    GraphQLBoolean
} from 'graphql';
import DateGenerator from '../_customTypes/DateGenerator'
import { fetchStockPrice } from '../stock_price/resolvers'
import StockPriceType from '../stock_price/typeDef'
import UserType from '../users/typeDef'
import StockType from '../stocks/typeDef'
import { findUser } from '../users/resolvers';
import { fetchStock } from '../stocks/resolvers';
// import StockType from '../stock/typeDef'

export default new GraphQLObjectType({
    name: 'holdings',
    description: 'holdings',
    fields: function () {
        return {
            stock_uuid: {
                type: GraphQLString
            },
            user_uuid: {
                type: GraphQLString
            },
            quantity: {
                type: GraphQLInt
            },
            user: {
                type: UserType,
                resolve: findUser
            },
            stock: {
                type: StockType,
                resolve: fetchStock
            }

        }
    }
});