import {
    GraphQLList,
    GraphQLInt,
    GraphQLNonNull,
    GraphQLString
} from 'graphql';
import StockPriceType from './typeDef';
import {
    fetchStockPrice
} from './resolvers';

const queries = {},
    mutations = {};


queries.stock_price = {
    type: GraphQLList(StockPriceType),
    description: 'StockPrice',
    args: {
        stock_uuid: {
            type: GraphQLNonNull(GraphQLString)
        }
    },
    resolve: fetchStockPrice
}

// queries.users = {
//     type: GraphQLList(UserType),
//     description: 'List all users in the system',
//     resolve: fetchUsers
// }



/*********************/

// mutations.createUser = {
//     type: UserType,
//     description: 'Allows to create a new user',
//     args: {
//         username: {
//             type: GraphQLString,
//             description: 'Email of the user'
//         }
//     },
//     resolve: createUser
// }



export {
    queries,
    mutations
}   