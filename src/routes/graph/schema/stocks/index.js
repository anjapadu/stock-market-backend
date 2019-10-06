import {
    GraphQLList,
    GraphQLInt,
    GraphQLNonNull,
    GraphQLString
} from 'graphql';
import StockType from './typeDef';
import {
    fetchStocks
} from './resolvers';

const queries = {},
    mutations = {};


queries.stocks = {
    type: GraphQLList(StockType),
    description: 'Stock',
    resolve: fetchStocks
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