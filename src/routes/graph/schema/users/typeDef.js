import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLInt,
    GraphQLList,
    GraphQLBoolean,
    GraphQLFloat
} from 'graphql';
import DateGenerator from '../_customTypes/DateGenerator'

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
            // password: {
            //     type: GraphQLString,
            //     description: 'Password for the user'
            // },
            admin: {
                type: GraphQLBoolean,
                description: 'User flag admin'
            },
            balance: {
                type: GraphQLFloat,
            }
        }
    }
});