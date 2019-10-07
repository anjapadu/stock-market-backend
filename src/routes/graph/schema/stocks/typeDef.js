import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLInt,
    GraphQLList,
    GraphQLBoolean,
    GraphQLFloat
} from 'graphql';
import DateGenerator from '../_customTypes/DateGenerator'
import { fetchStockPrice, fetchLastPrice } from '../stock_price/resolvers'
import StockPriceType from '../stock_price/typeDef'

export default new GraphQLObjectType({
    name: 'stocks',
    description: 'stocks',
    fields: function () {
        return {
            uuid: {
                type: GraphQLString,
                description: 'UUID of the stock'
            },
            name: {
                type: GraphQLString,
                description: 'Stock name - Company'
            },
            description: {
                type: GraphQLString,
                description: 'Description of the stock'
            },
            companylogo: {
                type: GraphQLString,
            },
            companyname: {
                type: GraphQLString,
                description: 'Company that own the stock'
            },
            quantity: {
                type: GraphQLInt,
                description: 'Total actions existing'
            },
            currency: {
                type: GraphQLString,
                description: 'Currency of stock - PEN / USD'
            },
            last_price: {
                type: StockPriceType,
                resolve: fetchLastPrice
            },
            stock_price_history: {
                type: GraphQLList(StockPriceType),
                resolve: fetchStockPrice
            }
        }
    }
});