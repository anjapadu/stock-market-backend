import {
    GraphQLList,
    GraphQLInt,
    GraphQLNonNull,
    GraphQLString
} from 'graphql';
import UserType from './typeDef';
import {
    logInUser, findUser, fetchUsers,
} from './resolvers';

const queries = {},
    mutations = {};


queries.login = {
    type: UserType,
    description: 'To login to the dashboard',
    args: {
        username: {
            type: GraphQLNonNull(GraphQLString),
            description: 'User name. In this case is an email.'
        },
        password: {
            type: GraphQLNonNull(GraphQLString),
            description: 'Password of the account. Min 8 length'
        }
    },
    resolve: logInUser
}

queries.user = {
    type: UserType,
    description: '',
    args: {
        uuid: {
            type: GraphQLString
        }
    },
    resolve: findUser
}

queries.users = {
    type: GraphQLList(UserType),
    description: '',

    resolve: fetchUsers
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