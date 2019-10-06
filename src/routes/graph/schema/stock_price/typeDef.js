import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLInt,
    GraphQLList,
    GraphQLFloat,
    GraphQLBoolean
} from 'graphql';
import DateGenerator from '../_customTypes/DateGenerator'

export default new GraphQLObjectType({
    name: 'stock_price',
    description: 'stock_price',
    fields: function () {
        return {
            uuid: {
                type: GraphQLString,
                description: 'UUID of the stock'
            },
            stock_uuid: {
                type: GraphQLString,
                description: 'Stock UUID reference'
            },
            close_price: {
                type: GraphQLFloat,
                description: 'Description of the stock'
            },
            timestamp: DateGenerator('timestamp'),
            change_price: {
                type: GraphQLFloat,
                description: 'Total actions existing'
            },
            change_percent: {
                type: GraphQLFloat,
                description: 'Currency of stock - PEN / USD'
            }
        }
    }
});