import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLInt,
    GraphQLList,
    GraphQLBoolean,
    GraphQLFloat
} from 'graphql';
import DateGenerator from '../_customTypes/DateGenerator'
import HoldingType from '../holdings/typeDef'
import ParamsType from '../params/typeDef'
import { fetchUsersHoldings, fetchHoldings } from '../holdings/resolvers';
import { getParams } from './resolvers';

export default new GraphQLObjectType({
    name: 'users',
    description: 'users',
    fields: function () {
        return {
            uuid: {
                type: GraphQLString,
                description: 'UUID of the user'
            },
            username: {
                type: GraphQLString,
                description: 'Username of the user'
            },
            admin: {
                type: GraphQLBoolean,
                description: 'User flag admin'
            },
            balance: {
                type: GraphQLFloat,
                resolve: ({ balance }) => {
                    return balance
                }
            },
            holdings: {
                type: GraphQLList(HoldingType),
                resolve: fetchHoldings
            },
            params: {
                type: ParamsType,
                resolve: getParams
            }
        }
    }
});