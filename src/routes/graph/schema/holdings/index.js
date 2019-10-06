import {
    GraphQLList,
    GraphQLInt,
    GraphQLNonNull,
    GraphQLString
} from 'graphql';
import StockType from './typeDef';
import {
    fetchHoldings
} from './resolvers';

const queries = {},
    mutations = {};


queries.holdings = {
    type: GraphQLList(StockType),
    args: {
        user_uuid: {
            type: GraphQLNonNull(GraphQLString)
        }
    },
    description: 'Holdings',
    resolve: fetchHoldings
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